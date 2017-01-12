package Ch10

/**
  * Created by terzeron on 2016. 12. 1..
  */
import ElementFactory.elem

abstract class Element {
  // 멤버 메소드 선언
  def contents: Array[String]
  println(contents)
  def width: Int = if (height == 0) 0 else contents(0).length
  def height: Int = contents.length

  def above(that: Element): Element =
    elem(this.contents ++ that.contents)

  def beside(that: Element): Element = {
    elem(
      for (
        (line1, line2) <- this.contents zip that.contents
      ) yield line1 + line2
    )
  }

  override def toString = contents mkString "\n"
}
