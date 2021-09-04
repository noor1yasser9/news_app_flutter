import 'package:news_app/model/source_response.dart';
import 'package:news_app/repository/NewsRepository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<SourceResponse> _subject = BehaviorSubject();

  getSource() async {
    SourceResponse response = await _repository.getSources();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SourceResponse> get subject => _subject;
}

final getSourcesBloc = GetSourceBloc();
