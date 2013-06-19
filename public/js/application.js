function jobStatusResponse(jobData){
  var $jobData = jobData;
  return function(data){
    jsonObj = JSON.parse(data);
    if (jsonObj.jobStatus === true){
      $('div#status').html('<h1>Success</h1>');
    } else {
      $('div#status').html('<h1>Pending</h1>');
      checkJobStatus($jobData);
    }
  } 
}

function checkJobStatus(data){
  jsonObj = JSON.parse(data);
  $.get('/status/' + jsonObj.jobId, jobStatusResponse(data))
}

function onSubmitTweet(event){
  event.preventDefault();
  var status = $('#status').val();
  $.post('/tweet', { status: status }, checkJobStatus);
}


$(document).ready(function() {
 $('#submit_tweet').on('click', onSubmitTweet)
});
