package Ch07

/**
  * Created by terzeron on 2016. 11. 28..
  */
object ProceduralTest {
  def main(args: Array[String]): Unit = {
    def makeRowSeq(row: Int) =
      for (col <- 1 to 10) yield {
        val prod = (row * col).toString
        val padding = " " * (4 - prod.length)
        padding + prod
      }

    def makeRow(row: Int) = makeRowSeq(row).mkString

    def multiTable() = {
      val tableSeq =
        for (row <- 1 to 10)
          yield makeRow(row)
      tableSeq.mkString("\n")
    }

    multiTable
  }
}
