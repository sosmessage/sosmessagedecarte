package fr.arnk.sosmessage

import scala.util.Random

import unfiltered.request._
import unfiltered.response._
import com.mongodb.casbah.MongoConnection
import net.liftweb.json.JsonAST._
import net.liftweb.json.JsonDSL._
import net.liftweb.json.Printer._
import net.liftweb.json.JsonParser._
import com.mongodb.casbah.commons.MongoDBObject
import org.bson.types.ObjectId
import com.mongodb.casbah.Imports._
import java.util.Date

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
      val skip = random.nextInt(if (count <= 0) 1 else count)

      val messages = messagesCollection.find(q).limit(-1).skip(skip)
      if (!messages.isEmpty) {
        val message = messages.next()

        val r = """
        function(doc, out) {
          for (var prop in doc.ratings) {
            out.count++;
            out.total += doc.ratings[prop];
          }
        }
        """
        val f = """
        function(out) {
          out.avg = out.total / out.count;
        }
        """
        val rating = messagesCollection.group(MongoDBObject("ratings" -> 1),
          MongoDBObject("_id" -> message.get("_id")), MongoDBObject("count" -> 0, "total" -> 0), r, f)
        val json = messageToJSON(message, Some(parse(rating.mkString)))
        JsonContent ~> ResponseString(pretty(render(json)))
      } else {
        NoContent
      }

    case req @ POST(Path(Seg("api" :: "v1" :: "category" :: categoryId :: "message" :: Nil))) =>
      categoriesCollection.findOne(MongoDBObject("_id" -> new ObjectId(categoryId))).map { category =>
        val Params(form) = req
        val text = form("text")(0)
        val builder = MongoDBObject.newBuilder
        builder += "categoryId" -> category.get("_id")
        builder += "category" -> category.get("name")
        builder += "text" -> text
        builder += "state" -> "waiting"
        builder += "createdAt" -> new Date()
        builder += "random" -> scala.math.random
        messagesCollection += builder.result
      }
      NoContent

    case req @ POST(Path(Seg("api" :: "v1" :: "message" :: messageId :: "rate" :: Nil))) =>
      val Params(form) = req
      val uid = form("uid")(0)
      val rating = if(form("rating")(0).toInt > 5) 5 else form("rating")(0).toInt
      val key = "ratings." + uid.replaceAll ("\\.", "-")
      messagesCollection.update(MongoDBObject("_id" -> new ObjectId(messageId)), $set (key -> rating), false, false)
      NoContent

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

  private def messageToJSON(message: DBObject, rating: Option[JValue] = None) = {
    val json = ("id", message.get("_id").toString) ~
    ("type", "message") ~
    ("category", message.get("category").toString) ~
    ("categoryId", message.get("categoryId").toString) ~
    ("text", message.get("text").toString) ~
    ("createdAt", message.get("createdAt").toString)

    rating match {
      case None => json ~ ("rating" -> 0) ~ ("ratingCount" -> 0)
      case Some(r) =>
        json ~ ("rating" -> rating \ "avg") ~ ("ratingCount" -> rating \ "count")
    }
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
