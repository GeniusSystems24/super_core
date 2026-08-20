/// State machine used to keep a stack expanded while a drag leaves the mouse
/// region and to collapse only after that external drag has ended.
sealed class SuperToastSwipeState {
  const SuperToastSwipeState();

  SuperToastSwipeState start() => this;
  SuperToastSwipeState end() => this;
  SuperToastSwipeState enter() => this;
  SuperToastSwipeState exit() => this;
}

class SuperToastUnswiped extends SuperToastSwipeState {
  const SuperToastUnswiped();

  @override
  SuperToastSwipeState start() => const SuperToastInternalSwipe();
}

class SuperToastInternalSwipe extends SuperToastSwipeState {
  const SuperToastInternalSwipe();

  @override
  SuperToastSwipeState end() => const SuperToastUnswiped();

  @override
  SuperToastSwipeState exit() => const SuperToastExternalSwipe();
}

class SuperToastExternalSwipe extends SuperToastSwipeState {
  const SuperToastExternalSwipe();

  @override
  SuperToastSwipeState end() => const SuperToastExternalEndSwipe();

  @override
  SuperToastSwipeState enter() => const SuperToastInternalSwipe();
}

class SuperToastExternalEndSwipe extends SuperToastSwipeState {
  const SuperToastExternalEndSwipe();

  @override
  SuperToastSwipeState end() => const SuperToastUnswiped();

  @override
  SuperToastSwipeState enter() => this;
}
