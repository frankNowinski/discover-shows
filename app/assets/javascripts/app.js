angular
  .module('app', ['ui.router', 'templates', 'ngMessages', 'ngCookies'])
  .config(function($stateProvider, $urlRouterProvider){
    $stateProvider
      .state('login', {
        url: '/login',
        templateUrl: 'app/views/login.html',
        controller: 'LoginController as login'
      })
      .state('home', {
        url: '/',
        templateUrl: 'app/views/home.html',
        controller: 'HomeController as home'
      })
      .state('home.artists', {
        url: 'artists',
        templateUrl: 'app/views/artists.html',
        controller: 'ArtistsController as artists',
        resolve: {
          items: function( ArtistService){
            return ArtistService.getArtists();
          }
        }
      })
      .state('home.artists.id', {
        url: '/artist/:id',
        templateUrl: 'app/views/artist.html',
        controller: 'ArtistController as artist',
        resolve: {
          item: function($stateParams, ArtistService){
            return ArtistService.getArtist($stateParams.id)
          },
          tracks: function($stateParams, ArtistService){
            return ArtistService.getSongs($stateParams.id)
          },
          events: function($stateParams, ConcertService){
            return ConcertService.getConcerts($stateParams.id)
          }
        }
      })
      .state('home.upcoming_concerts', {
        url: 'upcoming-concerts',
        templateUrl: 'app/views/upcoming_concerts.html',
        controller: 'UpcomingConcertsController as events'
      })
      .state('home.browse_concerts', {
        url: 'browse-concerts',
        templateUrl: 'app/views/browse_concerts.html',
        controller: 'BrowseConcertsController as events',
        resolve: {
          items: function(ConcertService){
            return ConcertService.getAllConcerts();
          }
        }
      });
    $urlRouterProvider.otherwise('/login')
  });
