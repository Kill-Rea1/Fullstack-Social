module.exports = {
    attributes: {
        post: {
            model: 'post',
            required: true
        },

        user: {
            model: 'user',
            required: true
        },
        
        postOwner: {
            model: 'user',
            required: true
        },

        postCreatedAt: {
            type: 'number',
            required: true
        },

        hasLiked: {
            type: 'boolean',
            defaultsTo: false
        }
    }
}