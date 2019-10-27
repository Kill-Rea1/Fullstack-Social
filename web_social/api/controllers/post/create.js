module.exports = async function(req, res) {
    const postBody = req.body.postBody
    sails.log.info("Create post object with text: " + postBody)

    // Waterline creation syntax
    const userId = req.session.userId
    await Post.create({text: postBody, user: userId}).fetch()

    res.redirect('/post')
}