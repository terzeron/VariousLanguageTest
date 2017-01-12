package Ch10

/**
  * Created by terzeron on 2016. 12. 1..
  */

import ElementFactory.elem

object ElementTest {
  def main(args: Array[String]): Unit = {
    println(elem(Array("music")) above elem("pops!!!"))
    println(elem(Array("classics", "jazz")) beside elem(Array("rock", "punk", "metal")))
  }
}
