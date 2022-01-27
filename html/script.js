$(document).ready(function () {
  HealthIndicator = new ProgressBar.Circle("#HealthIndicator", {
    color: "rgb(0, 255, 100)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  ArmourIndicator = new ProgressBar.Circle("#ArmourIndicator", {
    color: "rgb(0, 140, 255)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  HungerIndicator = new ProgressBar.Circle("#HungerIndicator", {
    color: "rgb(255, 164, 59)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  ThirstIndicator = new ProgressBar.Circle("#ThirstIndicator", {
    color: "rgb(0, 140, 170)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  StressIndicator = new ProgressBar.Circle("#StressIndicator", {
    color: "rgb(255, 74, 104)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  OxygenIndicator = new ProgressBar.Circle("#OxygenIndicator", {
    color: "rgb(0, 140, 255)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  SpeedIndicator = new ProgressBar.Circle("#SpeedIndicator", {
    color: "rgb(255, 255, 255)",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 10,
    trailWidth: 10,
    duration: 250,
    easing: "easeInOut",
  });

  FuelIndicator = new ProgressBar.Circle("#FuelIndicator", {
    color: "rgba(222, 222, 222, 1)",
    trailColor: "rgba(184, 184, 184, 0.082)",
    strokeWidth: 8,
    duration: 250,
    trailWidth: 8,
    easing: "easeInOut",
  });

  VoiceIndicator = new ProgressBar.Circle("#VoiceIndicator", {
    color: "#4a4a4a",
    trailColor: "rgb(35,35,35)",
    strokeWidth: 12,
    trailWidth: 12,
    duration: 250,
    easing: "easeInOut",
  });

  VoiceIndicator.animate(0.66);
});

window.addEventListener("message", function (event) {
  let data = event.data;

  if (data.action == "update_hud") {
    HealthIndicator.animate(data.hp / 100);
    ArmourIndicator.animate(data.armour / 100);
    HungerIndicator.animate(data.hunger / 100);
    ThirstIndicator.animate(data.thirst / 100);
    StressIndicator.animate(data.stress / 100);
    OxygenIndicator.animate(data.oxygen / 100);
    FuelIndicator.animate(data.fuel / 100);
  }

  if (data.action == "voice_level") {
    switch (data.voicelevel) {
      case 1:
        data.voicelevel = 33;
        break;
      case 2:
        data.voicelevel = 66;
        break;
      case 3:
        data.voicelevel = 100;
        break;
      default:
        data.voicelevel = 33;
        break;
    }

    VoiceIndicator.animate(data.voicelevel / 100);
  }

  if (data.showUi == true) {
    $(".container").fadeIn();
  } else if (data.showUi == false) {
    $(".container").fadeOut();
  }

  if (data.armour == 0) {
    $("#ArmourIndicator").fadeOut();
  } else if (data.armour > 0) {
    $("#ArmourIndicator").fadeIn();
  }

  if (data.showOxygen == true) {
    $("#OxygenIndicator").fadeIn();
  } else if (data.showOxygen == false) {
    $("#OxygenIndicator").fadeOut();
  }

  if (data.showSpeed == true) {
    $("#SpeedIndicator").fadeIn();
  } else if (data.showSpeed == false) {
    $("#SpeedIndicator").fadeOut();
  }

  if (data.showFuel == true) {
    $("#FuelIndicator").fadeIn();
  } else if (data.showFuel == false) {
    $("#FuelIndicator").fadeOut();
  }

  if (data.showStress == true) {
    $("#StressIndicator").fadeIn();
  } else if (data.showStress == false) {
    $("#StressIndicator").fadeOut();
  }

  if (data.thirst < 25) {
    $("#ThirstIcon").toggleClass("flash");
  }
  if (data.hunger < 25) {
    $("#HungerIcon").toggleClass("flash");
  }
  if (data.oxygen < 50) {
    $("#OxygenIcon").toggleClass("flash");
  }
  if (data.stress > 75) {
    $("#StressIcon").toggleClass("flash");
  }

  if (data.fuel < 0.2) {
    FuelIndicator.path.setAttribute("stroke", "red");
  } else if (data.fuel > 0.2) {
    FuelIndicator.path.setAttribute("stroke", "white");
  }

  if (data.talking == true) {
    VoiceIndicator.path.setAttribute("stroke", "yellow");
  } else if (data.talking == false) {
    VoiceIndicator.path.setAttribute("stroke", "darkgrey");
  }

  if (data.connection == false) {
    $("#VoiceIcon").removeClass("fa-microphone");
    $("#VoiceIcon").addClass("fa-times");
  } else if (data.connection == true) {
    $("#VoiceIcon").removeClass("fa-times");
    if (data.radio == true) {
      $("#VoiceIcon").removeClass("fa-microphone");
      $("#VoiceIcon").addClass("fa-headset");
    } else if (data.radio == false) {
      $("#VoiceIcon").removeClass("fa-headset");
      $("#VoiceIcon").addClass("fa-microphone");
    }
  }

  if (data.speed > 0) {
    if (data.speed >= data.maxspeed) {
      SpeedIndicator.animate(1);
    } else {
      SpeedIndicator.animate(data.speed / data.maxspeed);
    }
    $("#SpeedIcon").removeClass("fa-tachometer-alt");
    $("#SpeedIcon").text(data.speed);
  } else if (data.speed == 0) {
    SpeedIndicator.animate(0);
    $("#SpeedIcon").addClass("fa-tachometer-alt");
    $("#SpeedIcon").empty();
  }

  if (data.hp < 0) {
    HealthIndicator.animate(0);
    HealthIndicator.trail.setAttribute("stroke", "red");
    $("#HealthIcon").removeClass("fa-heart");
    $("#HealthIcon").addClass("fa-skull");
  } else if (data.hp > 0) {
    HealthIndicator.trail.setAttribute("stroke", "rgb(39,39,39)");
    $("#HealthIcon").removeClass("fa-skull");
    $("#HealthIcon").addClass("fa-heart");
  }
});
