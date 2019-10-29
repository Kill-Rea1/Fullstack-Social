module.exports = {
  friendlyName: 'Uploadfile',
  description: 'Uploadfile something.',

  inputs: {
    file: {
      type: 'ref',
      description: 'The file I want to upload to AWS S3'
    }
  },


  exits: {

    success: {
      description: 'All done.',
    },

  },


  fn: async function (inputs, exits) {
    console.log("Some text")

    const file = inputs.file

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
      return exits.success(fileUrl)
    })
  }
};

