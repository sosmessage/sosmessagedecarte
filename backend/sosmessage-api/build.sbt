organization := "fr.arnk"

name := "sosmessage-api"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
   "net.databinder" %% "unfiltered-filter" % "0.5.0",
   "net.databinder" %% "unfiltered-jetty" % "0.5.0",
   "net.databinder" %% "unfiltered-json" % "0.5.0",
   "com.mongodb.casbah" %% "casbah" % "2.1.5-1",
   "net.liftweb" %% "lift-json" % "2.4-M4",
   "net.databinder" %% "unfiltered-spec" % "0.5.0" % "test"
)
