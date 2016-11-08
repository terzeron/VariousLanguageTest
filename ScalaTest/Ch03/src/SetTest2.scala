/**
  * Created by terzeron on 2016. 11. 7..
  */
import scala.collection.mutable.Set

object SetTest2 {
  def main(args: Array[String]) {
    val movieSet = Set("Hitch", "Poltergeist")
    movieSet += "Shrek" // val인데도 변경 가능
    println(movieSet)
  }
}
