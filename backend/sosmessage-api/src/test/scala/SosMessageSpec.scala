package fr.arnk.sosmessage

import org.specs._

import dispatch._

object SosMessageSpec extends Specification with unfiltered.spec.jetty.Served {

  import dispatch._

  def setup = { _.filter(new SosMessage) }

  val http = new Http

  "The example app" should {
    "serve unfiltered requests" in {
      val status = http x (host as_str) {
        case (code, _, _, _) => code
      }
      status must_== 200
    }
  }
}
