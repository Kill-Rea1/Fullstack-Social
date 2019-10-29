module.exports = async function(req, res) {
    console.log("Trying to update user")
    const fullName = req.body.fullName
    const bio = req.body.bio 
    const file = req.file('imagefile')
    // no avatar file changed
    if (file.isNoop) {
        await User.update({id: req.session.userId})
            .set({fullName: fullName, bio: bio})
        file.upload({noop: true})
        res.end()
    }
    // save new avatar
    const options = {
        adapter: require('skipper-better-s3'),
        key: '',
        secret: '',
        bucket: 'full-stack-social',
        s3params: { ACL: 'public-read' }
    }

    file.upload(options, async (err, files) => {
        if (err) { return res.serverError(err.toString())}
        const fileUrl = files[0].extra.Location
        const userId = req.session.userId
        const record = await User.update({id: userId})
            .set({fullName: fullName, bio: bio, imageUrl: fileUrl}).fetch()
        console.log(JSON.parse(JSON.stringify(record)))
        res.end()
    })
}