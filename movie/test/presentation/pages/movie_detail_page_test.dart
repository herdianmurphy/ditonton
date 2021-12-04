import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}
class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MockMovieWatchlistBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class WatchlistMovieEventFake extends Fake implements WatchlistMovieEvent {}
class WatchlistMovieStateFake extends Fake implements WatchlistMovieState {}

class MockMovieRecommendationBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class MovieRecommendationEventFake extends Fake
    implements MovieRecommendationEvent {}
class MovieRecommendationStateFake extends Fake
    implements MovieRecommendationState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieRecommendationEventFake());
    registerFallbackValue(MovieRecommendationStateFake());
    registerFallbackValue(WatchlistMovieEventFake());
    registerFallbackValue(WatchlistMovieStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (context) => mockMovieDetailBloc,
        ),
        BlocProvider<MovieRecommendationBloc>(
          create: (context) => mockMovieRecommendationBloc,
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (context) => mockMovieWatchlistBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;
  final tMovieDetail = testMovieDetail;
  final tMovieList = testMovieList;

  group('Movie Detail', () {
    void _makeStubBloc() {
      when(() => mockMovieWatchlistBloc.add(any())).thenReturn(null);
      when(() => mockMovieRecommendationBloc.add(any())).thenReturn(null);
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieLoading());
      when(() => mockMovieRecommendationBloc.state)
          .thenReturn(MovieRecommendationLoading());
    }

    testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.add(FetchMovieDetail(tId))).thenReturn([]);
      when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
      final centerFinder = find.byType(Center);
      final circularFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(circularFinder, findsOneWidget);
    });

    testWidgets('Page should display detail content when data is loaded', (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.add(FetchMovieDetail(tId)))
          .thenReturn(tMovieDetail);
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(tMovieDetail));
      _makeStubBloc();

      final safeAreaFinder = find.byType(SafeArea);
      final detailContentFinder = find.byType(DetailContent);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(safeAreaFinder, findsOneWidget);
      expect(detailContentFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailError('Error'));

      final textFinder = find.byType(Text);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });

  group('Movie Recommendation', () {
    void _makeStubBloc() {
      when(() => mockMovieDetailBloc.add(FetchMovieDetail(tId)))
          .thenReturn(tMovieDetail);
      when(() => mockMovieWatchlistBloc.add(any())).thenReturn(null);
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(tMovieDetail));
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieLoading());
    }

    testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieRecommendationBloc.state)
          .thenReturn(MovieRecommendationLoading());

      final centerFinder = find.byKey(Key('center_mr'));
      final progressBarFinder = find.byKey(Key('cpi_mr'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieRecommendationBloc.add(FetchMovieRecommendation(tId)))
          .thenReturn(tMovieDetail);
      when(() => mockMovieRecommendationBloc.state)
          .thenReturn(MovieRecommendationHasData(tMovieList));

      final listViewFinder = find.byType(ListView);
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieRecommendationBloc.state)
          .thenReturn(MovieRecommendationError('Error Message'));

      final textFinder = find.byKey(Key('text_mr'));
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });

  group('Watchlist Movie', () {
    void _makeStubBloc() {
      when(() => mockMovieDetailBloc.add(FetchMovieDetail(tId)))
          .thenReturn(tMovieDetail);
      when(() => mockMovieRecommendationBloc.add(any())).thenReturn(null);
      when(() => mockMovieDetailBloc.state)
          .thenReturn(MovieDetailHasData(tMovieDetail));
      when(() => mockMovieRecommendationBloc.state)
          .thenReturn(MovieRecommendationLoading());
    }

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieWatchlistBloc.add(LoadWatchlistMovieStatus(tId)))
          .thenReturn(WatchlistMovieLoading());
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieLoading());

      final centerFinder = find.byKey(Key('center_wlm'));
      final progressBarFinder = find.byKey(Key('cpi_wlm'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display check icon when movie is added to wathclist',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieWatchlistBloc.add(SaveMovieToWatchlist(tMovieDetail)))
          .thenReturn(tMovieDetail);
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieLoaded(true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display add icon when movie not added to watchlist',
        (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieWatchlistBloc.add(RemoveMovieFromWatchlist(
            tMovieDetail,
          ))).thenReturn(tMovieDetail);
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieLoaded(false));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets('Watchlist button should display ElevatedButton when add to watchlist failed', (WidgetTester tester) async {
      _makeStubBloc();
      when(() => mockMovieWatchlistBloc.state)
          .thenReturn(WatchlistMovieError('Error'));

      final textFinder = find.byKey(Key('error_wlm'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: tId,
      )));

      expect(textFinder, findsOneWidget);
    });
  });
}
