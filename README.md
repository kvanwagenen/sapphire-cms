Sapphire CMS
============

Sapphire CMS is a rich-client content management system built on AngularJS. This frontend project requires a backend in order to function. Currently a Ruby on Rails engine is being developed in parallel (see [sapphire_cms_rails](http://github.com/kvanwagenen/sapphire_cms_rails)).

Concepts
--------

### Content Blocks

Instead of pages or articles, Sapphire CMS content is stored as flexible so called "content blocks". Any type of markup can be stored in these blocks, including Angular templates with directives, or vanilla HTML. They can then be published as pages, included in other content blocks, or injected into static Angular templates.

Features
--------

### Angular Integration

Because Sapphire CMS is implemented as a set of Angular modules, it can be easily included in existing Angular applications.

### Layouts

Sapphire CMS has native support for nested layouts. Any blocks that contain an 

	<sp-yield></sp-yield>

tag can be used as layouts for other blocks.

### Compiled Content

Blocks of content are compiled by Angular so they can contain directives. 

### Caching

After blocks are returned by the backend, they are cached in the client in the same way vanilla Angular templates are. This prevents additional requests to the backend and makes for a fast interface.

### Versioning

Blocks of content can be versioned so new blocks with the same slug can be developed without modifying previously published versions.

### Admin with ACE Editor

The block editor in the administrative interface uses the ACE editor to provide a rich code editing experience when developing site content.

### Plugin Support

Sapphire CMS can be extended by any number of plugins. Services, controllers, and directives are integrated as Angular modules, and templates can be installed to the database as editable content blocks. 

Development
-----------

### Gulp



Testing
-------

### Karma

License
-------