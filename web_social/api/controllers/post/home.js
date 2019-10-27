module.exports = async function(req, res) {
    // console.log("Show the post creation form now")
    sails.log.info("Show the post creation form now")

    const allPosts = await Post.find()

    res.view('pages/post/home', {
        allPosts
    })
}