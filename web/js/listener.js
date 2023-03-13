"use strict";
import Circle from "./circles.js";

window.onload = (event) => {
  fetch(`https://${GetParentResourceName()}/nuiReady`);

  const Container = document.getElementById("Container");
  const Logo = document.getElementById("Logo");
  const ID = document.getElementById("ID");

  const Speed = document.getElementById("SpeedIndicator");
  const Fuel = document.getElementById("FuelIndicator");
  const Voice = document.getElementById("VoiceIndicator");
  const Armour = document.getElementById("ArmourIndicator");
  const Stamina = document.getElementById("StaminaIndicator");
  const Oxygen = document.getElementById("OxygenIndicator");
  const Health = document.getElementById("HealthIndicator");
  const Hunger = document.getElementById("HungerIndicator");
  const Thirst = document.getElementById("ThirstIndicator");
  const Stress = document.getElementById("StressIndicator");

  const HealthIcon = document.getElementById("HealthIcon");
  const SpeedIcon = document.getElementById("SpeedIcon");
  const VoiceIcon = document.getElementById("VoiceIcon");
  const OxygenIcon = document.getElementById("OxygenIcon");
  const FuelIcon = document.getElementById("FuelIcon");
  const HungerIcon = document.getElementById("HungerIcon");
  const ThirstIcon = document.getElementById("ThirstIcon");
  const StressIcon = document.getElementById("StressIcon");

  const Seatbelt = document.getElementById("SeatbeltIcon");
  const Buckle = document.getElementById("buckle");
  const Unbuckle = document.getElementById("unbuckle");

  Circle.VoiceIndicator.animate(0.66);

  window.addEventListener("message", function (event) {
    let action = event.data.action;
    let data = event.data.message;

    if (action == "toggleHud") {
      Container.style.display = data ? "flex" : "none";
    }

    if (action == "setLogo") {
      Logo.style.display = "block";
    }

    if (action == "setPlayerId") {
      if (data) {
        ID.style.display = "block";
        ID.textContent = "#" + data;
      } else {
        ID.style.display = "none";
      }
    }

    if (action == "setHealth") {
      Health.style.display = "block";

      let health = (data.current - 100) / (data.max - 100);
      health < 0 && (health = 0);

      if (health) {
        HealthIcon.classList.remove("fa-skull");
        HealthIcon.classList.add("fa-heart");
      } else {
        HealthIcon.classList.remove("fa-heart");
        HealthIcon.classList.add("fa-skull");
      }

      Circle.HealthIndicator.trail.setAttribute(
        "stroke",
        health ? "rgb(35, 35, 35)" : "rgb(255, 0, 0)"
      );
      Circle.HealthIndicator.path.setAttribute(
        "stroke",
        health ? "rgb(0, 255, 100)" : "rgb(255, 0, 0)"
      );
      Circle.HealthIndicator.animate(health);
    }

    if (action == "setArmour") {
      Armour.style.display = "block";
      Circle.ArmourIndicator.animate(data / 100, function () {
        Armour.style.display = data == 0 && "none";
      });
    }

    if (action == "setStamina") {
      if (data) {
        Stamina.style.display = "block";

        let stamina = data.current / data.max;
        stamina < 0 && (stamina = 0);
        stamina < 0.1 && StaminaIcon.classList.toggle("flash");

        Circle.StaminaIndicator.path.setAttribute(
          "stroke",
          stamina < 0.1 ? "rgb(255, 0, 0)" : "rgb(255, 255, 200)"
        );
        Circle.StaminaIndicator.animate(stamina);
      } else {
        Circle.StaminaIndicator.animate(1, function () {
          Stamina.style.display = "none";
        });
      }
    }

    if (action == "setOxygen") {
      if (data) {
        Oxygen.style.display = "block";

        let oxygen = data.current / data.max;
        oxygen < 0 && (oxygen = 0);
        oxygen < 0.1 && OxygenIcon.classList.toggle("flash");

        Circle.OxygenIndicator.path.setAttribute(
          "stroke",
          oxygen < 0.1 ? "rgb(255, 0, 0)" : "rgb(0, 140, 255)"
        );
        Circle.OxygenIndicator.animate(oxygen);
      } else {
        Circle.OxygenIndicator.animate(1, function () {
          Oxygen.style.display = "none";
        });
      }
    }

    if (action == "setVehicle") {
      if (data) {
        Speed.style.display = "block";

        let speed = data.speed.current * data.unitsMultiplier;
        let maxSpeed = data.speed.max * data.unitsMultiplier;
        let percSpeed = (speed / maxSpeed) * 0.7;
        let fuel = data.fuel && data.fuel / 100;

        percSpeed > 1 && (percSpeed = 1);
        percSpeed >= 0.01 && SpeedIcon.classList.remove("fa-tachometer-alt");
        percSpeed >= 0.01 && (SpeedIcon.textContent = Math.floor(speed));
        percSpeed < 0.01 && SpeedIcon.classList.add("fa-tachometer-alt");
        percSpeed < 0.01 && (SpeedIcon.textContent = "");

        if (data.electric == true) {
          FuelIcon.classList.remove("fa-gas-pump");
          FuelIcon.classList.add("fa-bolt");
          fuel = 1;
        } else {
          FuelIcon.classList.remove("fa-bolt");
          FuelIcon.classList.add("fa-gas-pump");
        }

        Fuel.style.display = fuel !== false ? "block" : "none";
        fuel <= 0.15 && FuelIcon.classList.toggle("flash");
        Circle.FuelIndicator.path.setAttribute(
          "stroke",
          fuel > 0.15 ? "rgb(255, 255, 255)" : "rgb(255, 0, 0)"
        );

        Circle.SpeedIndicator.animate(percSpeed);
        Circle.FuelIndicator.animate(fuel);
      } else {
        Circle.SpeedIndicator.animate(0, function () {
          Speed.style.display = "none";
        });
        Circle.FuelIndicator.animate(0, function () {
          Fuel.style.display = "none";
        });
      }
    }

    if (action == "setVoice") {
      Voice.style.display = "block";
      if (data == "disconnected") {
        VoiceIcon.classList.remove("fa-microphone");
        VoiceIcon.classList.add("fa-times");
        Circle.VoiceIndicator.path.setAttribute("stroke", "rgb(255, 0, 0)");
        Circle.VoiceIndicator.trail.setAttribute("stroke", "rgb(255, 0, 0)");
      } else {
        VoiceIcon.classList.remove("fa-times");
        VoiceIcon.classList.add("fa-microphone");
        Circle.VoiceIndicator.path.setAttribute(
          "stroke",
          data ? "rgb(255, 255, 0)" : "rgb(169, 169, 169)"
        );
        Circle.VoiceIndicator.trail.setAttribute("stroke", "rgb(35, 35, 35)");
      }
    }

    if (action == "setVoiceRange") {
      switch (data) {
        case 0:
          data = 15;
          break;
        case 1:
          data = 33;
          break;
        case 2:
          data = 66;
          break;
        case 3:
          data = 100;
          break;
        default:
          data = 33;
          break;
      }

      Circle.VoiceIndicator.animate(data / 100);
    }

    if (action == "status") {
      Hunger.style.display = "block";
      Thirst.style.display = "block";
      Stress.style.display = data.stress > 5 && "block";

      data.hunger < 15 && HungerIcon.classList.toggle("flash");
      data.thirst < 15 && ThirstIcon.classList.toggle("flash");
      data.stress > 50 && StressIcon.classList.toggle("flash");

      Circle.HungerIndicator.animate(data.hunger / 100);
      Circle.ThirstIndicator.animate(data.thirst / 100);
      Circle.StressIndicator.animate(data.stress / 100, function () {
        Stress.style.display = data.stress <= 5 && "none";
      });
    }

    if (action == "setSeatbelt") {
      Seatbelt.style.display = data.toggled ? "block" : "none";
      Seatbelt.style.color = data.buckled
        ? "rgb(0, 255, 100)"
        : "rgb(255, 100, 100)";
    }

    if (action == "playSound") {
      switch (data) {
        case "unbuckle":
          Unbuckle.volume = 0.2;
          Unbuckle.play();
          break;
        case "buckle":
          Buckle.volume = 0.2;
          Buckle.play();
          break;
        default:
          break;
      }
    }
  });
};
