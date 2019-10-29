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
    const fileUrl = await sails.helpers.uploadfile(file)
    const userId = req.session.userId
    const record = await User.update({id: userId})
        .set({fullName: fullName, bio: bio, imageUrl: fileUrl}).fetch()
    console.log(JSON.parse(JSON.stringify(record)))
    res.end()
}