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
      val categoryOrder = MongoDBObject("name" -> 1)
      val categories = categoriesCollection.find().sort(categoryOrder).foldLeft(List[JValue]())((l, a) =>
        categoryToJSON(a) :: l
      ).reverse
      val json = ("count", categories.size) ~ ("items", categories)
      JsonContent ~> ResponseString(pretty(render(json)))

    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "messages" :: Nil))) =>
      val messageOrder = MongoDBObject("createdAt" -> -1)
      val q = MongoDBObject("categoryId" -> new ObjectId(id), "state" -> "approved")
      val messages = messagesCollection.find(q).sort(messageOrder).foldLeft(List[JValue]())((l, a) =>
        messageToJSON(a) :: l
      ).reverse
      val json = ("count", messages.size) ~ ("items", messages)
      JsonContent ~> ResponseString(pretty(render(json)))

    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "message" :: Nil))) =>
      val q = MongoDBObject("categoryId" -> new ObjectId(id), "state" -> "approved")
      val count = messagesCollection.find(q).count
      val skip = random.nextInt(count)

      val message = messagesCollection.find(q).limit(-1).skip(skip).next()

      val json = messageToJSON(message)
      JsonContent ~> ResponseString(pretty(render(json)))

//    case GET(Path(Seg("api" :: "v1" :: "category" :: id :: "randomMessage" :: Nil))) =>
//      val random = scala.math.random
//      println(random)
//      val q: DBObject = ("random" $gte random) ++ ("categoryId" -> new ObjectId(id))
//      messagesCollection.findOne(q) match {
//        case None =>
//          val q: DBObject = ("random" $lte random) ++ ("categoryId" -> new ObjectId(id))
//          val message = messagesCollection.findOne(q).get
//          val json = messageToJSON(message)
//          JsonContent ~> ResponseString(pretty(render(json)))
//        case Some(message) =>
//          val json = messageToJSON(message)
//          JsonContent ~> ResponseString(pretty(render(json)))
//      }
  }

  private def messageToJSON(o: DBObject) = {
    ("id", o.get("_id").toString) ~
    ("type", "message") ~
    ("category", o.get("category").toString) ~
    ("categoryId", o.get("categoryId").toString) ~
    ("text", o.get("text").toString) ~
    ("createdAt", o.get("createdAt").toString)
  }

  private def categoryToJSON(o: DBObject) = {
    ("id", o.get("_id").toString) ~
    ("type", "category") ~
    ("name", o.get("name").toString)
  }

}


object AppServer {
  def main(args: Array[String]) {
    unfiltered.jetty.Http(3000).filter(new SosMessage).run
  }
}
