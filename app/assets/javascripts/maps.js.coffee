# Initialize Google maps

googleMaps = ->
  $("#map_button").click ->

    $("#map_canvas").css {"height": "300px","border-style": "solid"}
    $("#map_canvas").animate {"opacity": 1 }, 1000

    myLatlng = new google.maps.LatLng(55.78965, 37.5956)
    mapOptions =
      center: myLatlng,
      zoom: 16,
      disableDefaultUI: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP

    myMap = new google.maps.Map($("#map_canvas")[0], mapOptions)

    markerOptions =
      position: myLatlng,
      map: myMap,
      icon: "/assets/map/marker.png"

    myMarker = new google.maps.Marker(markerOptions)
    myMarker.setAnimation(google.maps.Animation.BOUNCE)

    return 0

# Load

$ ->
  googleMaps()
