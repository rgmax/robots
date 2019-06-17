const Koa = require('koa')
const router = require('./robot')

const app = new Koa()
app
  .use(router.routes())
  .use(router.allowedMethods());
app.listen(4200)

console.log("Hi!")
console.log("I'm a robot!")
console.log("My name is Robo-Koa!")
