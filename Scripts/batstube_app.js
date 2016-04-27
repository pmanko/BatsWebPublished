var VidApp = angular.module('VidApp', ['ngRoute']);

VidApp.controller('VideoCtrl', ['$scope', '$http', '$location', function ($scope, $http, $location) {


    $scope.model = {
        currentVideo: undefined
    };

    $scope.angleChoice = {
        mainOnly: true
    };

    $scope.videos = [];
    $scope.model.currentVideo = null;

    //console.log(videoPaths);
    //console.log(videoTitles);

    // KeyDown Events
    $(document).on("keydown", function (event) {

        if (event.which == 32) { // SPACE
            event.preventDefault();
            $scope.pause();
        }
        else if (event.which == 37 || event.which == 65) { // LEFT
            event.preventDefault();
            $scope.stepBack();
        }
        else if (event.which == 38 || event.which == 87) { // UP
            event.preventDefault();
            $scope.play();
        }
        else if (event.which == 39 || event.which == 68) { // RIGHT
            event.preventDefault();
            $scope.stepForward();
        }

        else if (event.which == 40 || event.which == 83) { // DOWN
            event.preventDefault();
            $scope.slow();
        }

    });


    $scope.setupVideos = function (x) {
        $scope.sentVideos = [];
        for (var i = 0; i < videoPaths.length; i++) {
            if (videoPaths[i] != "") {
                //console.log($.trim(videoTitles[i]).length);
                if (!$scope.angleChoice.mainOnly || $.trim(videoTitles[i]).length > 1) {
                    $scope.sentVideos.push(
                        {
                            path: videoPaths[i].trim().replace(/\s+/g, "/").replace("192.169.190.40", "vids6.sydexsports.net"),
                            title: videoTitles[i]
                        }
                    );
                }

            }
        };
    };

    $scope.setupVideos();
    $scope.model.currentVideo = $scope.sentVideos[0];

    videojs("main_vid", { "controls": true, "autoplay": false, "preload": "auto", techOrder: ["html5", "flash"] }, function () {
        this.trigger("loadstart");

        this.src([{ type: "video/mp4", src: $scope.model.currentVideo.path }]);
        this.errorDisplay.close();

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

            if (myvid.paused()) {
                myvid.play();
            } else {
                myvid.pause();
            }
        });
    };
}]);

