// Generated by CoffeeScript 1.7.1
define(['jquery', 'utils'], function($, utils) {
  var api, gKey, geoUrl, get, post, taKey, taUrl;
  taKey = '379b8b313eaf439d92c521e5fe64a8ce';
  taUrl = 'http://api.tripadvisor.com/api/partner/2.0';
  gKey = 'AIzaSyC-5SLDR76m00GGODHxQ6gXGYtB4sXmP2s';
  geoUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
  get = function(url, done) {
    return $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json'
    }).done(done).fail(function(a, b, c) {
      console.log(a);
      console.log(b);
      return console.log(c);
    });
  };
  post = function(url, done) {
    return $.ajax({
      type: 'POST',
      url: url,
      dataType: 'json'
    }).done(done).fail(function(a, b, c) {
      console.log(a);
      console.log(b);
      return console.log(c);
    });
  };
  return api = {
    addTrip: function(trip) {
      return false;
    },
    geoCode: function(list, cb) {
      var key, keys, total, _fn, _i, _len;
      keys = utils.keys(list);
      total = keys.length;
      _fn = function(key) {
        var item, url;
        item = list[key];
        url = geoUrl + key + '&key=' + gKey;
        return get(url, function(result) {
          var location;
          location = result.results[0].geometry.location;
          list[key].name = result.results[0].address_components[0].long_name;
          list[key].lat = location.lat;
          list[key].lng = location.lng;
          total--;
          if (total === 0) {
            return cb(list);
          }
        });
      };
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        _fn(key);
      }
    },
    taLocation: function(id, option, cb) {
      var url, value;
      if (cb == null) {
        cb = option;
        option = null;
      }
      url = taUrl + '/location/' + id;
      if ((option != null) && option.type) {
        url += '/' + option.type;
      }
      url += '?key=' + taKey;
      if ((option != null) && option.subcategory) {
        url += '&subcategory=' + option.subcategory;
      }
      if ((option != null) && option.limit) {
        url += '&limit=' + option.limit;
      }
      if ((option != null) && option.offset) {
        url += '&offset=' + option.offset;
      }
      if (typeof localStorage !== "undefined" && localStorage !== null) {
        value = localStorage.getItem(url);
        if (value != null) {
          return cb(JSON.parse(value));
        }
      }
      return get(url, function(result) {
        if (typeof localStorage !== "undefined" && localStorage !== null) {
          localStorage.setItem(url, JSON.stringify(result));
        }
        return cb(result);
      });
    },
    taIds: function(coords, cb) {
      return this.taMap(coords, function(result) {
        var ancestors, city, country;
        ancestors = result.data[0].ancestors;
        city = ancestors[0];
        country = ancestors[ancestors.length - 1];
        return cb({
          place: {
            name: result.data[0].name,
            id: result.data[0].location_id
          },
          city: {
            name: city.name,
            id: city.location_id
          },
          country: {
            name: country.name,
            id: country.location_id
          }
        });
      });
    },
    taMapBox: function(coords1, coords2, option, cb) {
      var url, value;
      if (cb == null) {
        cb = option;
        option = null;
      }
      url = taUrl + '/map/' + coords1.lat + ',' + coords1.lng + ',' + coords2.lat + ',' + coords2.lng;
      if ((option != null) && option.type) {
        url += '/' + option.type;
      }
      url += '?key=' + taKey;
      if ((option != null) && option.subcategory) {
        url += '&subcategory=' + option.subcategory;
      }
      if (typeof localStorage !== "undefined" && localStorage !== null) {
        value = localStorage.getItem(url);
        if (value != null) {
          return cb(JSON.parse(value));
        }
      }
      return get(url, function(result) {
        if (typeof localStorage !== "undefined" && localStorage !== null) {
          localStorage.setItem(url, JSON.stringify(result));
        }
        return cb(result);
      });
    },
    taMap: function(coords, option, cb) {
      var url, value;
      if (cb == null) {
        cb = option;
        option = null;
      }
      url = taUrl + '/map/' + coords.lat + ',' + coords.lng;
      if ((option != null) && option.type) {
        url += '/' + option.type;
      }
      url += '?key=' + taKey;
      if ((option != null) && option.subcategory) {
        url += '&subcategory=' + option.subcategory;
      }
      if (typeof localStorage !== "undefined" && localStorage !== null) {
        value = localStorage.getItem(url);
        if (value != null) {
          return cb(JSON.parse(value));
        }
      }
      return get(url, function(result) {
        if (typeof localStorage !== "undefined" && localStorage !== null) {
          localStorage.setItem(url, JSON.stringify(result));
        }
        return cb(result);
      });
    }
  };
});
