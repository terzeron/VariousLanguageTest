package bobsrockets {
  package navigation {

    import Ch13.Booster3
    package launch {
      class Booster1
    }

    class MissionControl {
      val booster1 = new launch.Booster1
      val booster2 = new bobsrockets.launch.Booster2
      val booster3 = new Booster3
    }
  }

  package launch {
    class Booster2
  }
}
