angular.module("app", ['ngRoute', 'textAngular'])
.config(
  function ($routeProvider, $locationProvider) {
    //$locationProvider.html5Mode(true);
    $routeProvider.when('/', {
      templateUrl: '/home.tmplt.html'
    }).when('/create/0', {
      controller: "SelectEventCtrl",
      templateUrl: '/selectevent.tmplt.html'
    }).when('/create/1', {
      controller: "QuestionsCtrl",
      templateUrl: '/questions.tmplt.html'
    }).when('/create/2', {
      controller: "CocCtrl",
      templateUrl: '/coc.tmplt.html'
    }).when('/create/3', {
      controller: "EmailCtrl",
      templateUrl: '/emaildate.tmplt.html'
    })
    .when('/dash/:id', {
      controller: "DashCtrl",
      templateUrl: '/dash.tmplt.html'
    })
    .when('/dash/:cid/report/:id', {
      controller: "ReportCtrl",
      templateUrl: '/viewreport.tmplt.html'
    });
  }
)
.controller("SelectEventCtrl", function ($scope, $location, $http, $rootScope) {
  $scope.events = [];
  $scope.selectedEvent = null;

  $http.get("/eb/evt")
    .success(function(data) {
      $scope.events = data;
    })
    .error(function(data) {
      alert("Problem fetching events!");
    });

  $scope.goToQuestions = function () {
    $rootScope.eventID = $scope.selectedEvent;
    $location.path("/create/1");
  }
})
.controller("QuestionsCtrl", function($scope, $location, $http, $rootScope) {
  $scope.questions = [
    {
      text: "Any specific concerns that aren't part of a standard Code of Conduct?",
      propName : "concerns",
      type: "text"
    },
    {
      text: "Parties subject to the Code of Conduct?",
      propName : "parties",
      type: "text"
    },
    {
      text: "Overnight event?",
      propName : "overnight",
      type: "bool"
    },
    {
      text: "Alcohol served?",
      propName : "alcohol",
      type: "bool"
    },
    {
      text: "Minimum age of registrants?",
      propName : "minAge",
      type: "number"
    }
  ]

  $scope.curQuestion = 0;

  $scope.inputVal = null;

  $scope.result = {};

  $scope.onNext = function () {
    $scope.result[$scope.questions[$scope.curQuestion].propName] = $scope.inputVal;
    $scope.inputVal = null;
    $scope.curQuestion++;
    if ($scope.curQuestion === $scope.questions.length) {
      console.log($rootScope);
      $scope.result.eventID = $rootScope.eventID;
      $http.post("/question", $scope.result)
        .success(function(data) {
          $rootScope.conductID = data.conductID;
          $rootScope.htmlData = data.htmlData;
          $location.path("/create/2");
        })
        .error(function(err) {
          alert("Problem sending question answers!");
        })
    }
  }
})
.controller("CocCtrl", function($scope, $http, $rootScope, $location) {
  $scope.cocHTML = "";

  $scope.$watch(function(){return $rootScope.htmlData;}, function(n){$scope.cocHTML = n;});

  $scope.save = function() {
    $http.post("/conduct", {htmlData:$scope.cocHTML, conductID: $rootScope.conductID})
      .success(function(data) {
        $location.path("/create/3");
      })
      .error(function(err) {
        alert("Problems saving changes!");
      })
  }
}).controller("EmailCtrl", function($scope, $http, $rootScope, $location) {
  $scope.selection = null;

  $scope.save = function() {
    $http.post("/conduct/send", {time:$scope.selection, conductID: $rootScope.conductID})
      .success(function(data) {
        $location.path("/dash");
      })
      .error(function(err) {
        alert("Problems saving send date!");
      })
  }
})
.controller("DashCtrl", function($scope, $routeParams, $http) {
      $scope.newStaff = {
        name: "",
        phone: ""
      }

      $scope.conductID = $routeParams.id;
      $scope.staff = [];
      $scope.reports = [];

      $http.get("/conduct/" + $routeParams.id + "/staff")
        .success(function(data) {
          $scope.staff = data;
        })
        .error(function(data) {
          alert("Problem fetching staff list!");
        });

      $http.get("/conduct/" + $routeParams.id + "/report")
        .success(function(data) {
          $scope.reports = data;
        })
        .error(function(data) {
          alert("Problem fetching report list!");
        });

      $scope.saveStaff = function () {
        $http.post("/conduct/staff", {
          conductID: $routeParams.id,
          name: $scope.newStaff.name,
          phone: $scope.newStaff.phone
        })
        .success(function(data) {
          $scope.staff.push($scope.newStaff);
          $scope.newStaff = {
            name: "",
            phone: ""
          };
        })
        .error(function(err) {
          alert("Error saving new staff member");
        });
      }
})
.controller("ReportCtrl", function($scope, $http, $routeParams) {
  $scope.report = {
    reportID: $routeParams.id,
    name: "",
    email:"",
    description:""
  };
  $scope.cid = $routeParams.cid;

  $http.get("/conduct/" + $routeParams.cid + "/report/" + $routeParams.id)
    .success(function(data) {
      $scope.report = data;
    })
    .error(function(data) {
      alert("Problem fetching report!");
    });
});
