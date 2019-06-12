const chai = require('chai')
const chaiHttp = require('chai-http')

const url = "http://localhost:4200"
const expect = chai.expect

chai.use(chaiHttp)

describe("Robot greeting", () => {
  it("Robot should greet in correct way", (done) => {
    chai.request(url)
      .get('/robot')
      .end((err, res) => {
        expect(err).to.be.null
        expect(res.body.data).to.equal("Hi! I'm robot")
        done()
      })
  })
})
