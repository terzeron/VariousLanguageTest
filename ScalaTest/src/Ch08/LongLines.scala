package Ch08

/**
  * Created by terzeron on 2016. 11. 28..
  */

import scala.io.Source

object LongLines {
  def processFile(filename: String, width: Int): Unit = {
    def processLine(line: String): Unit = {
      if (line.length > width)
        println(s"${filename}: ${line.trim}")
    }

    val source = Source.fromFile(filename)
    for (line <- source.getLines())
      processLine(line)
  }


}
