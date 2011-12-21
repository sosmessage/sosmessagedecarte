organization := "fr.arnk"

name := "sosmessage-api"

version := "1.0-SNAPSHOT"

seq(com.github.retronym.SbtOneJar.oneJarSettings: _*)

libraryDependencies ++= Seq(
  "net.databinder" %% "unfiltered-filter" % "0.5.3",
  "net.databinder" %% "unfiltered-netty-server" % "0.5.3",
  "net.databinder" %% "unfiltered-json" % "0.5.3",
  //"com.mongodb.casbah" %% "casbah" % "2.1.5-1",
  "com.mongodb.casbah" %% "casbah" % "3.0.0-SNAPSHOT",
  "org.streum" %% "configrity" % "0.9.0",
  "ch.qos.logback" % "logback-classic" % "0.9.28",
  "net.databinder" %% "unfiltered-spec" % "0.5.0" % "test"
)
