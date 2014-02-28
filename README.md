Topic Model Visualizations
==========================

Termite is a visual analysis tool for inspecting the output of statistical topic models.

The tool contains two components:
  * **[Termite Data Server](http://github.com/uwdata/termite-data-server)** for processing the output of topic models and distributing the content as a web service
  * **[Termite Visualizations](http://github.com/uwdata/termite-visualizations)** for visualizing topic model outputs in a web browser

This repository contains the web-based visualizations, which include:
  * a web server for distributing the visualizations
  * various interactive visualizations

This software is developed by [Jason Chuang](http://jason.chuang.ca) and Ashley Jin, and distributed under the BSD-3 license.

Launch visualizations
---------------------

To launch the visualization server, execute the following command. A dialogue box will appear. Click on "start server" to proceed.

```
./start_client.sh
```

Make sure you also launch or connect to a corresponding [Termite Data Server](https://github.com/uwdata/termite-server).

The visualizations will be available at:

```
http://127.0.0.1:8080/
```

Active Research Project
=======================

This is an active research project. While we would like to support as many users as possible, we are constrained by available resources. Below are the system requirements and known issues.

System requirements
-------------------

  * **Python 2.7** for web2py and server scripts
  * **Modern web browsers** for the interactive visualizations

Known issues
------------

"Modern web browsers" can have multiple interpretations. See [D3 Browser Support](https://github.com/mbostock/d3/wiki#wiki-browser-support) and [jQuery Browser Support](http://jquery.com/browser-support/) for basic requirements. Internally, we develop and test the visualizations in Chrome.

Credits
-------

Termite requires the use of the following software. We thank their respective authors for developing and distributing these tools.

  * [D3](http://d3js.org) by Mike Bostock
  * [Backbone](http://backbonejs.org) by Jeremy Ashkenas, DocumentCloud Inc.
  * [Underscore](http://underscorejs.org) by Jeremy Ashkenas, DocumentCloud Inc.
  * [jQuery](http://jquery.com) by jQuery Foundation
  * [Closure](https://developers.google.com/closure/compiler) by Google
  * [YUI](http://yuilibrary.com) by Yahoo!
  * [Font Awesome](http://fontawesome.io) by Dave Gandy  
  * [The web2py Web Framework](http://web2py.com) by Massimo Di Pierro, et al.

License
-------

Copyright (c) 2013, Leland Stanford Junior University
Copyright (c) 2014, University of Washington
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
  * Neither the name of the <organization> nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
