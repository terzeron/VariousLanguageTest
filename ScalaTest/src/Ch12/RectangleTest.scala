package Ch12

/**
  * Created by terzeron on 2016. 12. 19..
  */
object RectangleTest {
  def main(args: Array[String]): Unit = {
    val r = new Rectangle(new Point(2, 5), new Point(1, 14))
    println(r.width)
  }
}

class Point(val x: Int, val y: Int)

class Rectangle(val topLeft: Point, val bottomRight: Point) extends Rectangular {
}

trait Rectangular {
  def topLeft: Point
  def bottomRight: Point
  def left = topLeft.x
  def right = bottomRight.x
  def width = right - left
}