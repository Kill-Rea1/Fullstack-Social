module.exports = async function(req, res) {
    const postBody = req.body.postBody
    sails.log.info("Create post object with text: " + postBody)
    const file = req.file('imagefile')
    try {
        const fileUrl = await sails.helpers.uploadfile(file)
        const userId = req.session.userId
        const record = await Post.create({text: postBody,
            user: userId,
            imageUrl: fileUrl
        }).fetch()

        await FeedItem.create({
            post: record.id,
            postOwner: userId,
            user: userId,
            postCreatedAt: record.createdAt
        })

        res.redirect('/')
    } catch (err) {
        res.serverError(err)
    }
}