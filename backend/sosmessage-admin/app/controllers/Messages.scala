package controllers

import _root_.net.liftweb.json.JsonParser._
import play.api._
import data._
import play.api.mvc._
import com.mongodb.casbah.commons.MongoDBObject
import com.mongodb.casbah.MongoConnection
import org.bson.types.ObjectId
import java.util.Date
import com.mongodb.DBObject
import com.mongodb.casbah.Imports._

object Messages extends Controller {

  val DataBaseName = "sosmessage"
  val MessagesCollectionName = "messages"
  val CategoriesCollectionName = "categories"

  val mongo = MongoConnection()

  val messagesCollection = mongo(DataBaseName)(MessagesCollectionName)
  val categoriesCollection = mongo(DataBaseName)(CategoriesCollectionName)

  val messageForm = Form(
    of(
      "category" -> requiredText,
      "text" -> requiredText,
      "approved" -> optional(text)
    )
  )

  def index(categoryId: String = "none") = Action { implicit request =>
    val categoryOrder = MongoDBObject("name" -> 1)
    val categories = categoriesCollection.find().sort(categoryOrder).foldLeft(List[DBObject]())((l, a) =>
      a :: l
    ).reverse

    val selectedCategoryId = if (categoryId == "none") {
      categories(0).get("_id").toString
    } else {
      categoryId
    }

    val messageOrder = MongoDBObject("createdAt" -> -1)
    val q = MongoDBObject("categoryId" -> new ObjectId(selectedCategoryId), "state" -> "approved")
    val messages = messagesCollection.find(q).sort(messageOrder).foldLeft(List[DBObject]())((l, a) =>
      a :: l
    ).map(addRating(_))reverse

    Ok(views.html.messages.index(categories, selectedCategoryId, messages, messageForm))
  }

  def addRating(message: DBObject) = {
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
    val j = parse(rating.mkString)
    message.put("rating", j \ "avg" values)
    message.put("ratingCount", (j \ "count" values).asInstanceOf[Double].toInt)
    message
  }

  def save(selectedCategoryId: String) = Action { implicit request =>
    messageForm.bindFromRequest().fold(
      f => {
        println("bad: " + f)
        Redirect(routes.Messages.index(selectedCategoryId))
      },
      v => {
        val oid = new ObjectId(v._1)
        val o = MongoDBObject("_id" -> oid)
        val category = categoriesCollection.findOne(o).get
        val builder = MongoDBObject.newBuilder
        builder += "categoryId" -> category.get("_id")
        builder += "category" -> category.get("name")
        builder += "text" -> v._2
        val actionDone = v._3 match {
          case None =>
            builder += "state" -> "waiting"
            "messageWaiting"
          case Some(s) =>
            builder += "state" -> "approved"
            "messageAdded"
        }
        builder += "createdAt" -> new Date()
        builder += "random" -> scala.math.random
        messagesCollection += builder.result

        Redirect(routes.Messages.index(category.get("_id").toString)).flashing("actionDone" -> actionDone)
      }
    )
  }

  def delete(selectedCategoryId: String, messageId: String) = Action { implicit request =>
    val oid = new ObjectId(messageId)
    val o = MongoDBObject("_id" -> oid)
    messagesCollection.remove(o)
    Redirect(routes.Messages.index(selectedCategoryId)).flashing("actionDone" -> "messageDeleted")
  }

}
