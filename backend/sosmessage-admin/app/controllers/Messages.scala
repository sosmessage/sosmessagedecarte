package controllers

import play.api._
import data._
import play.api.mvc._
import com.mongodb.casbah.commons.MongoDBObject
import com.mongodb.casbah.MongoConnection
import org.bson.types.ObjectId
import java.util.Date
import com.mongodb.DBObject

object Messages extends Controller {

  val DataBaseName = "sosmessage"
  val MessagesCollectionName = "messages"
  val CategoriesCollectionName = "categories"

  val mongo = MongoConnection()

  val messagesCollection = mongo(DataBaseName)(MessagesCollectionName)
  val categoriesCollection = mongo(DataBaseName)(CategoriesCollectionName)

  val messageForm = Form(
    of(
      "category" -> text(minLength = 1),
      "text" -> text(minLength = 1)
    )
  )

  def index(categoryId: String = "none") = Action {
    val categoryOrder = MongoDBObject("name" -> 1)
    val categories = categoriesCollection.find().sort(categoryOrder).foldLeft(List[DBObject]())((l, a) =>
      a :: l
    ).reverse

    val selectedCategoryId = if (categoryId == "none") {
      categories(0).get("_id").toString
    } else {
      categoryId
    }

    val messageOrder = MongoDBObject("createdAt" -> 1)
    val q = MongoDBObject("categoryId" -> new ObjectId(selectedCategoryId))
    val messages = messagesCollection.find(q).sort(messageOrder).foldLeft(List[DBObject]())((l, a) =>
      a :: l
    ).reverse
    Ok(views.html.messages.index(categories, selectedCategoryId, messages, messageForm))
  }

  def save(selectedCategoryId: String) = Action { implicit request =>
    messageForm.bindFromRequest().fold(
      f => {
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
        builder += "createdAt" -> new Date()
        builder += "random" -> scala.math.random
        messagesCollection += builder.result

        Redirect(routes.Messages.index(selectedCategoryId))
      }
    )
  }

  def delete(selectedCategoryId: String, messageId: String) = Action {
    val oid = new ObjectId(messageId)
    val o = MongoDBObject("_id" -> oid)
    messagesCollection.remove(o)
    Redirect(routes.Messages.index(selectedCategoryId))
  }

}
