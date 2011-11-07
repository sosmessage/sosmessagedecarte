package controllers

import play.api._
import data._
import play.api.mvc._
import com.mongodb.casbah.commons.MongoDBObject
import com.mongodb.casbah.MongoConnection
import org.bson.types.ObjectId
import java.util.Date

object Application extends Controller {

  val DataBaseName = "sosmessage"
  val MessagesCollectionName = "messages"
  val CategoriesCollectionName = "categories"

  val mongo = MongoConnection()

  val messagesCollection = mongo(DataBaseName)(MessagesCollectionName)
  val categoriesCollection = mongo(DataBaseName)(CategoriesCollectionName)

  val categoryForm = Form(
      "name" -> text(minLength = 1)
  )

  val messageForm = Form(
    of(
      "category" -> text(minLength = 1),
      "text" -> text(minLength = 1)
    )
  )

  def index = Action {
    Ok(views.html.index(categoriesCollection, messagesCollection, categoryForm, messageForm))
  }

  def saveMessage = Action { implicit request =>
    messageForm.bindFromRequest().fold(
      f => {
        BadRequest(views.html.index(categoriesCollection, messagesCollection, categoryForm, messageForm))
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
        messagesCollection += builder.result

        Redirect(routes.Application.index)
      }
    )
  }

  def deleteMessage(id: String) = Action {
    val oid = new ObjectId(id)
    val o = MongoDBObject("_id" -> oid)
    messagesCollection.remove(o)
    Redirect(routes.Application.index)
  }

  def saveCategory = Action { implicit request =>
    categoryForm.bindFromRequest().fold(
      f => {
        Logger.info("baaad?" + f)
        BadRequest(views.html.index(categoriesCollection, messagesCollection, categoryForm, messageForm))
      },
      v => {
        Logger.info("saving cate?")
        val builder = MongoDBObject.newBuilder
        builder += "name" -> v
        builder += "createdAt" -> new Date()
        categoriesCollection += builder.result

        Redirect(routes.Application.index)
      }
    )
  }

  def deleteCategory(id: String) = Action {
    val oid = new ObjectId(id)
    val o = MongoDBObject("_id" -> oid)
    categoriesCollection.remove(o)
    Redirect(routes.Application.index)
  }

}
