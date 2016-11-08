/**
  * Created by terzeron on 2016. 11. 7..
  */
object ListTest {
  def main(args: Array[String]) {
    val thrill = "Will"::"fill"::"until"::Nil
    println(thrill.dropRight(2))
    println(thrill.drop(2))
    println(thrill.exists(s => s == "until"))
    println(thrill.filter(s => s == "until"))
    println(thrill.forall(s => s == "until"))
    thrill.foreach(println)
    thrill.foreach(s => println(s))
    println(thrill.head)
    println(thrill.tail)
    println(thrill.map(s => s+ "y"))
  }
}
