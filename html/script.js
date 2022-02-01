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
    color: "red",
    trailColor: "red",
    strokeWidth: 12,
    trailWidth: 12,
    duration: 250,
    easing: "easeInOut",
  });

  VoiceIndicator.animate(0.66);
});

window.addEventListener("message", function (event) {
  let data = event.data;

  if (data.action == "general") {
    HealthIndicator.animate(data.hp / 100);
    ArmourIndicator.animate(data.armour / 100);

    if (data.oxygen < 0) data.oxygen = 0;
    OxygenIndicator.animate(data.oxygen / 100);

    if (data.hp < 0) {
      HealthIndicator.animate(0);
      HealthIndicator.trail.setAttribute("stroke", "red");
      $("#HealthIcon").removeClass("fa-heart");
      $("#HealthIcon").addClass("fa-skull");
    } else if (data.hp > 0) {
      HealthIndicator.trail.setAttribute("stroke", "rgb(35,35,35)");
      $("#HealthIcon").removeClass("fa-skull");
      $("#HealthIcon").addClass("fa-heart");
    }

    if (data.armour == 0) {
      $("#ArmourIndicator").fadeOut();
    } else if (data.armour > 0) {
      $("#ArmourIndicator").fadeIn();
    }

    if (data.oxygen < 100) {
      $("#OxygenIndicator").fadeIn();
      if (data.oxygen < 25) {
        OxygenIndicator.path.setAttribute("stroke", "red");
        $("#OxygenIcon").toggleClass("flash");
      } else {
        OxygenIndicator.path.setAttribute("stroke", "rgb(0, 140, 255)");
        $("#OxygenIcon").removeClass("flash");
      }
    } else if (data.oxygen == 100) {
      $("#OxygenIndicator").fadeOut();
    }

    if (data.showVoice == true) {
      $("#VoiceIndicator").fadeIn();
      if (data.voiceConnected == false) {
        VoiceIndicator.path.setAttribute("stroke", "red");
        VoiceIndicator.trail.setAttribute("stroke", "red");
        $("#VoiceIcon").removeClass("fa-microphone");
        $("#VoiceIcon").addClass("fa-times");
      } else if (data.voiceConnected == true) {
        VoiceIndicator.trail.setAttribute("stroke", "rgb(35,35,35)");
        $("#VoiceIcon").removeClass("fa-times");
        $("#VoiceIcon").addClass("fa-microphone");
        if (data.voiceTalking == true) {
          VoiceIndicator.path.setAttribute("stroke", "yellow");
        } else if (data.voiceTalking == false) {
          VoiceIndicator.path.setAttribute("stroke", "darkgrey");
        }
      }
    }

    if (data.showSpeedo == true) {
      let speedoLevel = data.speed / (data.maxspeed * 1.3);
      if (speedoLevel > 1) speedoLevel = 1;
      SpeedIndicator.animate(speedoLevel);

      $("#SpeedIndicator").fadeIn();
      if (data.speed > 0) {
        $("#SpeedIcon").removeClass("fa-tachometer-alt");
        $("#SpeedIcon").text(data.speed);
      } else if (data.speed == 0) {
        $("#SpeedIcon").addClass("fa-tachometer-alt");
        $("#SpeedIcon").empty();
      }
    } else if (data.showSpeedo == false) {
      $("#SpeedIndicator").fadeOut();
    }

    if (data.showFuel == true) {
      FuelIndicator.animate(data.fuel / 100);
      if (data.fuel < 0.2) {
        FuelIndicator.path.setAttribute("stroke", "red");
      } else if (data.fuel > 0.2) {
        FuelIndicator.path.setAttribute("stroke", "white");
      }
      $("#FuelIndicator").fadeIn();
    } else if (data.showFuel == false) {
      $("#FuelIndicator").fadeOut();
      FuelIndicator.animate(0);
    }
  }

  if (data.action == "status") {
    HungerIndicator.animate(data.hunger / 100);
    ThirstIndicator.animate(data.thirst / 100);
    
    if (data.stress) {
      StressIndicator.animate(data.stress / 100);
      $("#StressIndicator").fadeIn();
      if (data.stress > 75) {
        $("#StressIcon").toggleClass("flash");
      }
    }

    if (data.thirst < 25) {
      $("#ThirstIcon").toggleClass("flash");
    }

    if (data.hunger < 25) {
      $("#HungerIcon").toggleClass("flash");
    }
  }

  if (data.action == "voice_range") {
    switch (data.voiceRange) {
      case 1:
        data.voiceRange = 33;
        break;
      case 2:
        data.voiceRange = 66;
        break;
      case 3:
        data.voiceRange = 100;
        break;
      default:
        data.voiceRange = 33;
        break;
    }

    VoiceIndicator.animate(data.voiceRange / 100);
  }

  if (data.showUi == true) {
    $(".container").show();
  } else if (data.showUi == false) {
    $(".container").hide();
  }
});
