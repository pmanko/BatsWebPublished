var VidApp = angular.module('VidApp', ['ngRoute']);

VidApp.controller('PathCtrl', ['$scope', function ($scope) {



}]);

VidApp.controller('VideoCtrl', ['$scope', '$http', '$location', function ($scope, $http, $location) {
    // var paths = $location.search().paths;
    // var titles = $location.search().titles;
    // var network_path = false;

    $scope.model = {
        currentVideo: undefined
    };
    
    $scope.angleChoice = {
        mainOnly : false
    };


    // if (paths) {
    //     path = paths.split(';');
    //     network_path = true;
    // }       
    // else
    //     paths = ["/Images/1288A.mp4", "/Images/1289A.mp4", "/Images/1290A.mp4", "/Images/1291A.mp4"];
    // 
    // if (titles)
    //     titles = titles.split(';');
    // else
    //     titles = ["Example Video 1", "Example Video 2", "Example Video 3", "Example Video 4"];

    $scope.videos = [];
    $scope.model.currentVideo = null;

    //console.log(videoPaths);
    //console.log(videoTitles);


    


//     for (var i = 0; i < paths.length; i++) {
//         if (paths[i].replace(/ /g, '') != "") {
//             if (network_path) {
//                 vid_info = {
//                     path: "/Content" + paths[i].replace(/ /g, '').replace(/"/, '').replace(/\\/g, "/").split("MAJORS")[1],
//                     title: titles[i].trim()
//                 }
//             } else {
//                 vid_info = {
//                     path: paths[i],
//                     title: titles[i].trim()
//                 }
//             }
//             $scope.videos.push(vid_info);
// 
//         }            
//     }

    $scope.setupVideos = function (x) {
        $scope.sentVideos = [];
        for (var i = 0; i < videoPaths.length; i++) {
            if (videoPaths[i] != "") {
                //console.log($.trim(videoTitles[i]).length);
                if(!$scope.angleChoice.mainOnly || $.trim(videoTitles[i]).length > 1) {
                    $scope.sentVideos.push(
                        {
                            path: videoPaths[i].trim().replace(/\s+/g, "/").replace("192.169.250.162", "vids3.sydexsports.net"),
                            title: videoTitles[i]
                        }
                    );                    
                }

            }
        };        
    };

    $scope.setupVideos();
    $scope.model.currentVideo = $scope.sentVideos[0];

    videojs("main_vid", { "controls": true, "autoplay": false, "preload": "auto",  techOrder: ["html5", "flash"] }, function () {
        this.src([{ type: "video/mp4", src: $scope.model.currentVideo.path }]);
        this.play();
        
        this.on('ended', function () {
            $scope.$apply(function () {
                var next_vid_index = ($scope.sentVideos.indexOf($scope.model.currentVideo) + 1) % $scope.sentVideos.length;
                $scope.setCurrentVideo($scope.sentVideos[next_vid_index]);

            });
        });
    });




    $scope.setCurrentVideo = function (newVid) {


        $scope.model.currentVideo = newVid;

        videojs("main_vid").ready(function () {
            
            var myvid = this;
            var currentRate = myvid.playbackRate();
            //console.log(currentRate);
            myvid.errorDisplay.close();

            myvid.src([{ type: "video/mp4", src: newVid.path }]);
            myvid.addClass("embed-responsive-item");
	
	    myvid.defaultPlaybackRate = currentRate;
            myvid.play();
            this.playbackRate(currentRate);
        });
            
    };

    $scope.stepForward = function () {
        videojs("main_vid").ready(function () {
            var myvid = this;
            var fps = 29;
            var frameLength = 1 / fps;

            myvid.pause();

            myvid.currentTime(myvid.currentTime() + frameLength);
        });

    };

    $scope.stepBack = function () {
        videojs("main_vid").ready(function () { 
            var myvid = this;   
            var fps = 29;
            var frameLength = 1 / fps;

            myvid.pause();

            myvid.currentTime(myvid.currentTime() - frameLength);
        });
    };

    $scope.play = function () {
        videojs("main_vid").ready(function () {
            var myvid = this;
            this.defaultPlaybackRate = 1.0;
	               myvid.play();
	
            myvid.playbackRate(1.0);
        });
    };

    $scope.slow = function () {
        videojs("main_vid").ready(function () {
            this.defaultPlaybackRate = 0.25;
            this.play();
            this.playbackRate(0.25);

        });
    }

    $scope.pause = function () {
        videojs("main_vid").ready(function () {
            var myvid = this;

            this.pause();
        });
    };
}]);

