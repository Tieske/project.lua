describe("description: replace this file with your own tests", function()


  it("loads the module", function()
    local mymod

    assert.has.no.error(function()
      mymod = require "[module-name]"
    end)

    assert.is.table(mymod)
    assert.is.string(mymod._VERSION)
    assert.is.string(mymod._COPYRIGHT)
    assert.is.string(mymod._DESCRIPTION)
  end)

end)
