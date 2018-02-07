import { createStore } from 'redux/dist/redux.js';
console.log('redux-poc loaded');

$( document ).ready(function() {
  init();
});

const init = () => {
  function counter(state, action) {
    if (typeof state === 'undefined') {
      return 0
    }

    switch (action.type) {
      case 'INCREMENT':
      return state + 1
      case 'DECREMENT':
      return state - 1
      default:
      return state
    }
  }

  var store = createStore(counter)
  var valueEl = document.getElementById('value')

  function render() {
    valueEl.innerHTML = store.getState().toString()
  }

  render()
  store.subscribe(render)

  document.getElementById('increment')
  .addEventListener('click', function () {
    store.dispatch({ type: 'INCREMENT' })
  })

  document.getElementById('decrement')
  .addEventListener('click', function () {
    store.dispatch({ type: 'DECREMENT' })
  })

  document.getElementById('incrementIfOdd')
  .addEventListener('click', function () {
    if (store.getState() % 2 !== 0) {
      store.dispatch({ type: 'INCREMENT' })
    }
  })

  document.getElementById('incrementAsync')
  .addEventListener('click', function () {
    setTimeout(function () {
      store.dispatch({ type: 'INCREMENT' })
    }, 1000)
  })

}
