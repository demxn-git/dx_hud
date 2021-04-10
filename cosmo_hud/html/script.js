$(document).ready(function () {
  HPCircle = new ldBar("#HealthIndicator");
  HPCircleIcon = document.querySelector("#HealthIndicator path.baseline");
  ArmorCircle = new ldBar("#ArmorIndicator");
  ArmorCircleDiv = document.getElementById("ArmorIndicator");
  HungerCircle = new ldBar("#HungerIndicator");
  HungerCircleIcon = document.getElementsByClassName("fa-hamburger");
  ThirstCircle = new ldBar("#ThirstIndicator");
  ThirstCircleIcon = document.getElementsByClassName("fa-tint");
  OxygenCircle = new ldBar("#OxygenIndicator");
  OxygenCircleDiv = document.getElementById("OxygenIndicator");
});

window.addEventListener("message", function (event) {
  let data = event.data;

  HPCircle.set(data.hp);
  ArmorCircle.set(data.armor);
  HungerCircle.set(data.hunger);
  ThirstCircle.set(data.thirst);
  OxygenCircle.set(data.oxygen);
  
  // Change color and icon if HP is 0 (dead)
  if (data.hp < 0) {
    HPCircleIcon.style.stroke = "rgb(70, 0, 0)";
    HPCircleIcon.style.fill = "rgb(70, 0, 0)";
    $("#hp-icon").removeClass("fa-heart");
    $("#hp-icon").addClass("fa-skull");
  } else if (data.hp > 0) {
    HPCircleIcon.style.stroke = "rgb(0, 143, 71)";
    HPCircleIcon.style.fill = "rgb(0, 143, 71)";
    $("#hp-icon").removeClass("fa-skull");
    $("#hp-icon").addClass("fa-heart");
  }

  // Hide armor icon if 0
  if (data.armor == 0) {
    ArmorCircleDiv.style.display = "none";
  } else if (data.armor > 0) {
    ArmorCircleDiv.style.display = "block";
  }

  // Flash if hunger is low
  if (data.hunger < 25) {
    $(HungerCircleIcon).toggleClass("flash");
  }
  // Flash if thirst is low
  if (data.thirst < 25) {
    $(ThirstCircleIcon).toggleClass("flash");
  }

  // Show oxygen if underwater
  if (data.showOxygen == true) {
    $(OxygenCircleDiv).css("display", "block");
  } else if (data.showOxygen == false) {
    $(OxygenCircleDiv).css("display", "none");
  }

  if (data.speed > 0) {
    $("#SpeedIndicator").text(data.speed);
  } else if (data.speed == 0) {
    $("#SpeedIndicator").text("0");
  }
  if ((data.gear == 0) & (data.speed > 0)) {
    $("#GearIndicator").text("R");
    $("#GearIndicator").css("color", "red");
  } else if (data.gear > 0) {
    $("#GearIndicator").text(data.gear);
    $("#GearIndicator").css("color", "white");
  }
  if ((data.gear == 0) & (data.speed == 0)) {
    $("#GearIndicator").text("N");
    $("#GearIndicator").css("color", "white");
  }

  if (data.showSpeedo == true) {
    $("#VehicleContainer").fadeIn();
  } else if (data.showSpeedo == false) {
    $("#VehicleContainer").fadeOut();
  }

  if (data.showGear == true) {
    $("#GearIndicator").css("display", "block");
  } else if (data.showGear == false) {
    $("#GearIndicator").css("display", "none");
  }

  if (data.showUi == true) {
    $(".container").css("display", "block");
  } else if (data.showUi == false) {
    $(".container").css("display", "none");
  }
});
