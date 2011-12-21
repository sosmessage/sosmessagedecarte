package fr.arnk.sosmessage

import scala.util.Random

import unfiltered.request._
import unfiltered.response._
import unfiltered.netty._
import net.liftweb.json.JsonAST._
import net.liftweb.json.JsonDSL._
import net.liftweb.json.Printer._
import net.liftweb.json.JsonParser._
import com.mongodb.casbah.commons.MongoDBObject
import org.bson.types.ObjectId
import com.mongodb.casbah._
import java.util.Date
import org.streum.configrity.Configuration

class SosMessage(config: Configuration) extends async.Plan with ServerErrorResponse {

  val MessagesCollectionName = "messages"
  val CategoriesCollectionName = "categories"

  val dataBaseName = config[String]("database.name")

  val mongo = MongoConnection(config[String]("database.host", "127.0.0.1"), config[Int]("database.port", 27017))
  val messagesCollection = mongo(dataBaseName)(MessagesCollectionName)
  val categoriesCollection = mongo(dataBaseName)(CategoriesCollectionName)

  val random = new Random()

  def intent = {
    case req @ GET(Path("/api/v1/categories")) =>
      val categoryOrder = MongoDBObject("name" -> 1)
      val categories = categoriesCollection.find().sort(categoryOrder).foldLeft(List[JValue]())((l, a) =>
        categoryToJSON(a) :: l
      ).reverse
      val json = ("count", categories.size) ~ ("items", categories)
      req.respond(JsonContent ~> ResponseString(pretty(render(json))))

    case req @ GET(Path(Seg("api" :: "v1" :: "categories" :: id :: "messages" :: Nil))) =>
      val messageOrder = MongoDBObject("createdAt" -> -1)
      val q = MongoDBObject("categoryId" -> new ObjectId(id), "state" -> "approved")
      val keys = MongoDBObject("category" -> 1, "categoryId" -> 1, "text" -> 1, "createdAt" -> 1)
      val messages = messagesCollection.find(q, keys).sort(messageOrder).foldLeft(List[JValue]())((l, a) =>
        messageToJSON(a) :: l
      ).reverse
      val json = ("count", messages.size) ~ ("items", messages)
      req.respond(JsonContent ~> ResponseString(pretty(render(json))))

    case req @ GET(Path(Seg("api" :: "v1" :: "categories" :: id :: "message" :: Nil))) =>
      val q = MongoDBObject("categoryId" -> new ObjectId(id), "state" -> "approved")
      val count = messagesCollection.find(q, MongoDBObject("_id" -> 1)).count
      val skip = random.nextInt(if (count <= 0) 1 else count)

      val keys = MongoDBObject("category" -> 1, "categoryId" -> 1, "text" -> 1, "createdAt" -> 1)
      val messages = messagesCollection.find(q, keys).limit(-1).skip(skip)
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
          if (out.total == 0 || out.count == 0) {
            out.avg = 0;
          } else {
            out.avg = out.total / out.count;
          }
        }
        """
        val rating = messagesCollection.group(MongoDBObject("ratings" -> 1),
          MongoDBObject("_id" -> message.get("_id")), MongoDBObject("count" -> 0, "total" -> 0), r, f)
        val json = messageToJSON(message, Some(parse(rating.mkString)))
        req.respond(JsonContent ~> ResponseString(pretty(render(json))))
      } else {
        req.respond(NoContent)
      }

    case req @ POST(Path(Seg("api" :: "v1" :: "categories" :: categoryId :: "message" :: Nil))) =>
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
      req.respond(NoContent)

    case req @ POST(Path(Seg("api" :: "v1" :: "message" :: messageId :: "rate" :: Nil))) =>
      val Params(form) = req
      val uid = form("uid")(0)
      val rating = if(form("rating")(0).toInt > 5) 5 else form("rating")(0).toInt
      val key = "ratings." + uid.replaceAll ("\\.", "-")
      messagesCollection.update(MongoDBObject("_id" -> new ObjectId(messageId)), $set (key -> rating), false, false)
      req.respond(NoContent)

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
    val config = getConfig
    unfiltered.netty.Http(config[Int]("server.port", 3000)).handler(new SosMessage(config)).run
  }

  def getConfig: Configuration = {
    val defaultConfig = Configuration("database.host" -> "127.0.0.1",
      "database.port" -> 27017, "database.name" -> "sosmessage", "server.port" -> 3000)

    val systemConfig = Configuration.systemProperties
    systemConfig.get[String]("sosmessage.configurationFile") match {
      case None => defaultConfig
      case Some(filename) =>
        try {
          Configuration.load(filename)
        } catch {
          case e: Exception => defaultConfig
        }
    }
  }

}
