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
  val MessagesCollection = "messages"

  val mongo = MongoConnection()

  val messagesCollection = mongo(DataBaseName)(MessagesCollection)

  val messageForm = Form(
    of(
      "category" -> text(minLength = 1),
      "text" -> text(minLength = 1)
    )
  )

  def index = Action {
    Ok(views.html.index(messagesCollection, messageForm))
  }

  def save = Action { implicit request =>
    //Logger.info(request.body.)
    messageForm.bindFromRequest().fold(
      f => {
        BadRequest(views.html.index(messagesCollection, f))
      },
      v => {
        Logger.info("Saving object: {category: " + v._1 + ", text: " + v._2 + "}")
        val builder = MongoDBObject.newBuilder
        builder += "category" -> v._1
        builder += "text" -> v._2
        builder += "creationDate" -> new Date()
        messagesCollection += builder.result

        Redirect(routes.Application.index)
      }
    )
  }

  def delete(id: String) = Action {
    val oid = new ObjectId(id)
    val o = MongoDBObject("_id" -> oid)
    messagesCollection.remove(o)
    Redirect(routes.Application.index)
  }

}
