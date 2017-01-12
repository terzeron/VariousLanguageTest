package Ch07

/**
  * Created by terzeron on 2016. 11. 21..
  */
object WhileTest {
  def main(args: Array[String]): Unit = {
    var line = ""
    while ((line = readLine()) != "")
      // 탈출 불가
      println(line)
  }
}
