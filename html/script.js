document.addEventListener("DOMContentLoaded", function () {
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
  var data = event.data;

  if (data.action == "general") {
    HealthIndicator.animate(data.hp / 100);
    ArmourIndicator.animate(data.armour / 100);

    if (data.hp <= 0) {
      HealthIndicator.animate(0);
      HealthIndicator.trail.setAttribute("stroke", "red");
      document.getElementById("HealthIcon").classList.remove("fa-heart");
      document.getElementById("HealthIcon").classList.add("fa-skull");
    } else {
      HealthIndicator.trail.setAttribute("stroke", "rgb(35,35,35)");
      document.getElementById("HealthIcon").classList.remove("fa-skull");
      document.getElementById("HealthIcon").classList.add("fa-heart");
    }

    if (data.armour == 0) {
      document.getElementById("ArmourIndicator").style.display = "none";
    } else {
      document.getElementById("ArmourIndicator").style.display = "block";
    }

    if (data.oxygen < 100) {
      if (data.oxygen < 0) data.oxygen = 0;
      OxygenIndicator.animate(data.oxygen / 100);

      document.getElementById("OxygenIndicator").style.display = "block";
      if (data.oxygen < 25) {
        OxygenIndicator.path.setAttribute("stroke", "red");
        document.getElementById("OxygenIcon").classList.toggle("flash");
      } else {
        OxygenIndicator.path.setAttribute("stroke", "rgb(0, 140, 255)");
        document.getElementById("OxygenIcon").classList.remove("flash");
      }
    } else if (data.oxygen == 100) {
      document.getElementById("OxygenIndicator").style.display = "none";
    }

    if (data.showVoice == true) {
      document.getElementById("VoiceIndicator").style.display = "block";
      if (data.voiceConnected == false) {
        VoiceIndicator.path.setAttribute("stroke", "red");
        VoiceIndicator.trail.setAttribute("stroke", "red");

        document.getElementById("VoiceIcon").classList.remove("fa-microphone");
        document.getElementById("VoiceIcon").classList.add("fa-times");
      } else if (data.voiceConnected == true) {
        VoiceIndicator.trail.setAttribute("stroke", "rgb(35,35,35)");

        document.getElementById("VoiceIcon").classList.remove("fa-times");
        document.getElementById("VoiceIcon").classList.add("fa-microphone");
        if (data.voiceTalking == true) {
          VoiceIndicator.path.setAttribute("stroke", "yellow");
        } else if (data.voiceTalking == false) {
          VoiceIndicator.path.setAttribute("stroke", "darkgrey");
        }
      }
    }

    if (data.speedometer) {
      var speedoLevel =
        data.speedometer.speed / (data.speedometer.maxspeed * 1.3);
      if (speedoLevel > 1) speedoLevel = 1;
      SpeedIndicator.animate(speedoLevel);
      document.getElementById("SpeedIndicator").style.display = "block";

      if (data.speedometer.speed >= 1) {
        document
          .getElementById("SpeedIcon")
          .classList.remove("fa-tachometer-alt");
        document.getElementById("SpeedIcon").textContent =
          data.speedometer.speed;
      } else {
        document.getElementById("SpeedIcon").classList.add("fa-tachometer-alt");
        document.getElementById("SpeedIcon").textContent = "";
      }
    } else {
      SpeedIndicator.animate(0);
      document.getElementById("SpeedIndicator").style.display = "none";
    }

    if (data.fuel !== false && data.fuel >= 0) {
      FuelIndicator.animate(data.fuel / 100);
      document.getElementById("FuelIndicator").style.display = "block";

      if (data.fuel < 0.2) {
        FuelIndicator.path.setAttribute("stroke", "red");
      } else if (data.fuel > 0.2) {
        FuelIndicator.path.setAttribute("stroke", "white");
      }
    } else {
      FuelIndicator.animate(0);
      document.getElementById("FuelIndicator").style.display = "none";
    }
  }

  if (data.action == "status") {
    HungerIndicator.animate(data.hunger / 100);
    ThirstIndicator.animate(data.thirst / 100);

    if (data.stress > 5) {
      StressIndicator.animate(data.stress / 100);
      document.getElementById("StressIndicator").style.display = "block";

      if (data.stress > 50)
        document.getElementById("StressIcon").classList.toggle("flash");
    } else {
      StressIndicator.animate(0);
      document.getElementById("StressIndicator").style.display = "none";
    }

    if (data.thirst < 25) {
      document.getElementById("ThirstIcon").classList.toggle("flash");
    }

    if (data.hunger < 25) {
      document.getElementById("HungerIcon").classList.toggle("flash");
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

  if (data.playerId) {
    document.getElementById("ID").textContent = data.playerId;
  }

  if (data.showUi == true) {
    document.querySelector(".Container").style.display = "block";
    document.querySelector(".Logo").style.display = "block";
  } else if (data.showUi == false) {
    document.querySelector(".Container").style.display = "none";
    document.querySelector(".Logo").style.display = "none";
  }
});
