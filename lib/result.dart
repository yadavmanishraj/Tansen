sealed class Result {
  const Result();
}

class ResultSuccess implements Result {
  final List<String> response;
  const ResultSuccess(this.response);
}

class ResultFailure implements Result {
  final String errorMessage;
  const ResultFailure(this.errorMessage);
}

class ResultLoading implements Result {}

void main(List<String> args) {
  const Result data = ResultSuccess(["result"]);
  if (data.runtimeType == ResultFailure) {
    data as ResultFailure;
    data.errorMessage;
  }
}
