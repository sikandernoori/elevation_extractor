// class GeoJson {
// 	List<Features> features;
// 	String type;

// 	GeoJson({this.features, this.type});

// 	GeoJson.fromJson(Map<String, dynamic> json) {
// 		if (json['features'] != null) {
// 			features = new List<Features>();
// 			json['features'].forEach((v) { features.add(new Features.fromJson(v)); });
// 		}
// 		type = json['type'];
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		if (this.features != null) {
//       data['features'] = this.features.map((v) => v.toJson()).toList();
//     }
// 		data['type'] = this.type;
// 		return data;
// 	}
// }

// class Features {
// 	Geometry geometry;
// 	String id;
// 	Properties properties;
// 	String type;

// 	Features({this.geometry, this.id, this.properties, this.type});

// 	Features.fromJson(Map<String, dynamic> json) {
// 		geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
// 		id = json['id'];
// 		properties = json['properties'] != null ? new Properties.fromJson(json['properties']) : null;
// 		type = json['type'];
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		if (this.geometry != null) {
//       data['geometry'] = this.geometry.toJson();
//     }
// 		data['id'] = this.id;
// 		if (this.properties != null) {
//       data['properties'] = this.properties.toJson();
//     }
// 		data['type'] = this.type;
// 		return data;
// 	}
// }

// class Geometry {
// 	List<List> coordinates;
// 	String type;

// 	Geometry({this.coordinates, this.type});

// 	Geometry.fromJson(Map<String, dynamic> json) {
// 		if (json['coordinates'] != null) {
// 			coordinates = new List<List>();
// 			json['coordinates'].forEach((v) { coordinates.add(new List.fromJson(v)); });
// 		}
// 		type = json['type'];
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		if (this.coordinates != null) {
//       data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
//     }
// 		data['type'] = this.type;
// 		return data;
// 	}
// }

// class Coordinates {


// 	Coordinates({});

// 	Coordinates.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		return data;
// 	}
// }

// class Properties {
// 	int max;
// 	int min;

// 	Properties({this.max, this.min});

// 	Properties.fromJson(Map<String, dynamic> json) {
// 		max = json['max'];
// 		min = json['min'];
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		data['max'] = this.max;
// 		data['min'] = this.min;
// 		return data;
// 	}
// }
