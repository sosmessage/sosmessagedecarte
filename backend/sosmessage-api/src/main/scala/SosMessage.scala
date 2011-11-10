package fr.arnk.sosmessage

import scala.util.Random

import unfiltered.request._
import unfiltered.response._
import com.mongodb.casbah.MongoConnection
import net.liftweb.json.JsonAST._
import net.liftweb.json.JsonDSL._
import net.liftweb.json.Printer._
import com.mongodb.casbah.commons.MongoDBObject
import org.bson.types.ObjectId
import com.mongodb.casbah.Imports._
import com.mongodb.casbah.Implicits._

class SosMessage extends unfiltered.filter.Plan {

  val DataBaseName = "sosmessage"
  val MessagesCollectionName = "messages"
  val CategoriesCollectionName = "categories"

  val mongo = MongoConnection()

  val messagesCollection = mongo(DataBaseName)(MessagesCollectionName)
  val categoriesCollection = mongo(DataBaseName)(CategoriesCollectionName)

  val random = new Random()

  def intent = {
    case GET(Path("/api/v1/categories")) =>
      val categories = categoriesCollection.foldLeft(List[JValue]())((l, a) =>
        ("id", a.get("_id").toString) ~
        ("type", "category") ~
        ("name", a.get("name").toString)
        :: l
      )
      val json = ("count", categories.size) ~ ("items", categories)
      JsonContent ~> ResponseString(pretty(render(json)))

    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "messages" :: Nil))) =>
      val q = MongoDBObject("categoryId" -> new ObjectId(id))
      val messages = messagesCollection.find(q).foldLeft(List[JValue]())((l, a) =>
        ("id", a.get("_id").toString) ~
        ("type", "message") ~
        ("category", a.get("category").toString) ~
        ("categoryId", a.get("categoryId").toString) ~
        ("text", a.get("text").toString) ~
        ("createdAt", a.get("createdAt").toString)
        :: l
      )
      val json = ("count", messages.size) ~ ("items", messages)
      JsonContent ~> ResponseString(pretty(render(json)))

    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "message" :: Nil))) =>
      val q = MongoDBObject("categoryId" -> new ObjectId(id))
      val count = messagesCollection.find(q).count
      val skip = random.nextInt(count)

      val message = messagesCollection.find(q).limit(-1).skip(skip).next()

      val json = ("id", message.get("_id").toString) ~
        ("type", "message") ~
        ("category", message.get("category").toString) ~
        ("categoryId", message.get("categoryId").toString) ~
        ("text", message.get("text").toString) ~
        ("createdAt", message.get("createdAt").toString)
      JsonContent ~> ResponseString(pretty(render(json)))

    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "messageeuh" :: Nil))) =>
      val random = scala.math.random
      println(random)
      val q: DBObject = ("random" $gte random) ++ ("categoryId" -> new ObjectId(id))
      messagesCollection.findOne(q) match {
        case None =>
          val q: DBObject = ("random" $lte random) ++ ("categoryId" -> new ObjectId(id))
          val message = messagesCollection.findOne(q).get
          val json = ("id", message.get("_id").toString) ~
            ("type", "message") ~
            ("category", message.get("category").toString) ~
            ("categoryId", message.get("categoryId").toString) ~
            ("text", message.get("text").toString) ~
            ("createdAt", message.get("createdAt").toString)
          JsonContent ~> ResponseString(pretty(render(json)))
        case Some(o) =>
          val json = ("id", o.get("_id").toString) ~
            ("type", "message") ~
            ("category", o.get("category").toString) ~
            ("categoryId", o.get("categoryId").toString) ~
            ("text", o.get("text").toString) ~
            ("createdAt", o.get("createdAt").toString)
          JsonContent ~> ResponseString(pretty(render(json)))
      }
  }

}


object AppServer {
  def main(args: Array[String]) {
    unfiltered.jetty.Http(3000).filter(new SosMessage).run
  }
}
