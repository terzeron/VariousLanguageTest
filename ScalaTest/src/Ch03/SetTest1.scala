/**
  * Created by terzeron on 2016. 11. 7..
  */

//import scala.collection.mutable.Set

object SetTest1 {
  def main(args: Array[String]) {
    var jetSet = Set("Boeing", "Airbus")
    jetSet += "Lear"
    println(jetSet)
    println(jetSet.contains("Cessna"))

  }
}
