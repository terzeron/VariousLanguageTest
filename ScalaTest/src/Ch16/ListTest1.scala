package Ch16

/**
  * Created by terzeron on 2017. 1. 2..
  */
object ListTest1 {
  def main(args: Array[String]) = {
    val fruit: List[String] = List("apple", "orange", "pear")
    val nums: List[Int] = List(1, 2, 3, 4, 5)
    val diag3: List[List[Int]] = List(
      List(1, 0, 0),
      List(0, 1, 0),
      List(0, 0, 1)
    )
    val empty: List[Nothing] = List()
    val fruit2 = "apple" :: "orange" :: "pear" :: Nil
    val num2 = 1 :: 2 :: 3 :: 4 :: Nil
    val diag32 = (1 :: 0 :: 0 :: Nil) ::
      (0 :: 1 :: 0 :: Nil) ::
      (0 :: 0 :: 1 :: Nil) :: Nil
    val empty2 = Nil
    println(empty.isEmpty)
    println(fruit.isEmpty)
    println(fruit.head)
    println(fruit.tail)

    val ab = 'a' :: 'b' :: Nil
    val cd = 'c' :: 'd' :: Nil
    val abcd = ab ::: cd
    println(abcd)
    println(fruit.last)
    println(fruit.init)

    val values = List(1, 2, 3, 4, 5)
    println(values take 2)
    println(values drop 2)
    println(values splitAt 2)

    println(values(3))
    println(values.indices)

    println(List(List(1, 2), List(3), List(), List(4, 5)).flatten)
    println(fruit.map(_.toCharArray).flatten)

    println(values.map(_ * 2))
    println(values.flatMap(0 to _))
    println(values.foreach(println(_)))

    println(values.filter(_ > 3))
    println(values.partition(_ % 2 == 0))
    println(values.find(_ % 2 == 0))
    val values2 = List(1, 2, 3, -4, 5)
    println(values2.takeWhile(_ > 0))
    println(values2.dropWhile(_ > 0))
    println(values2.span(_ > 0))

    println(values.forall(_ > 0))
    println(values.forall(_ > 3))
    println(values.exists(_ == 3))
    println(values.exists(_ == 6))

    println(("Fruits:" /: fruit) (_ + " " + _))
    println((fruit :\ "Fruit:") (_ + " " + _))

    println((1 to 1000000).toStream.filter(_ % 2 == 0).map(Math.pow(2, _)).take(10).sum)
  }
}
