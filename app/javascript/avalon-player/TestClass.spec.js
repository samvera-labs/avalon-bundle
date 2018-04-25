import TestClass from './TestClass';
const testClass = new TestClass();

describe('Test Class', function() {
  it('passes first test', function() {
    expect(true).toBe(true);
  });

  it('handles a class function', function() {
    const foo = testClass.doSomething();
    console.log('foo', foo);
  });

});
