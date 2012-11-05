module.exports =
  astronomers:
    heading: 'Galaxy Zoo for Astronomers'
    
    explanation:
      goals: 'This page aims to give background to the scientific motivation behind the project for a more technical audience.'
      data: 'You may be looking for data - public Galaxy Zoo data is available in a range of formats <a href="http://data.galaxyzoo.org">here</a>.'
      papers: 'Alternatively, you can browse a list of papers published by the team <a href="/#/papers">here</a>.'
    
    morphology:
      heading: 'Why is galaxy morphology important?'
      body: '''To first order, the morphology of a galaxy is a tracer of the orbital dynamics of the stars in it, but it also carries an imprint of the processes driving star formation and nuclear activity in galaxies. Visual morphology produces classifications which are strongly correlated with other, physical parameters. To give a single example, the presence of multiple nuclei and extended tidal features indicates that the dominant mechanism driving star formation is an ongoing merger. Equally, the absence of such features implies that the evolution of the galaxy may be being driven by internal ('secular') processes.'''
      reference: '''Traditionally morphology has been derived either by visual inspection of galaxy images (e.g. <a href="http://adsabs.harvard.edu/abs/1926ApJ....64..321H" target="_blank">Hubble 1926</a>, <a href="http://heasarc.nasa.gov/W3Browse/all/rc3.html" target="_blank">de Vaucouleurs 1991</a>, and more recently e.g. <a href="http://arxiv.org/abs/1001.2401" target="_blank">Nair and Abraham 2010</a> or via morphological parameters, such as Concentration, Asymmetry, Clumpiness, M20, the Gini coefficient, etc (e.g. <a href="http://arxiv.org/abs/astro-ph/0303065" target="_blank">Conselice 2003</a>, <a href="http://adsabs.harvard.edu/abs/2008ApJ...672..177L" target="_blank">Lotz et al. 2008</a>. Strictly speaking, these parameters are morphological 'proxies', each with its own attendant biases, which are typically checked and calibrated against visual inspection. A visual approach is generally more resistant to changing signal-to-noise and resolution in images (e.g. Lisker 2008), making it an ideal method for determining galaxy morphology. Nevertheless, morphological parameters have been valuable for classifying large survey-scale datasets, for which visual inspection by individuals (or small groups of researchers) can be prohibitively time-consuming.'''
    
    classification:
      heading: 'Classifications of large survey datasets using Galaxy Zoo'
      body: 'Galaxy Zoo (<a href="http://arxiv.org/abs/0804.4483" target="_blank">Lintott et al. 2008</a>, <a href="http://arxiv.org/abs/1007.3265" target="_blank">2011</a>) pioneered a novel method for performing large-scale visual classifications of survey datasets. Using more than half a million members of the general public, the project has classified – via direct visual inspection - the entire Sloan Digital Sky Survey spectroscopic sample and all existing Hubble Space Telescope surveys (around 1.5 million galaxies in total). With more than 40 classifications per object, Galaxy Zoo provides both a visual classification and an associated uncertainty (which is challenging to estimate if there are only a few human classifiers). The classifications themselves have been demonstrated to be of comparable accuracy to those derived by expert astronomers (see Lintott et al. 2008).'
    
    highlights:
      heading: 'Galaxy Zoo science highlights'
      body: '''The Galaxy Zoo science programme has contributed to a diverse set of topics, largely focused on the nearby and intermediate-redshift Universe. Some recent highlights include the largest studies of galaxy mergers (<a href="http://arxiv.org/abs/0903.4937">Darg et al. 2010</a>), tidal dwarf galaxies (<a href="http://arxiv.org/abs/1108.4410">Kaviraj et al. 2012</a>), dust lanes in early-type galaxies (<a href="http://arxiv.org/abs/1107.5306">Kaviraj et al. 2012</a>) and bars in disc galaxies (<a href="http://arxiv.org/abs/1003.0449">Masters et al. 2011</a>, <a href="http://arxiv.org/abs/1205.5271">2012</a>) in the nearby Universe to date. One of the unique aspects of Galaxy Zoo over automated morphological measurements is the possibility of serendipitous discoveries (often aided by volunteer led discussion on the <a href="http://www.galaxyzooforum.org">Galaxy Zoo Forum</a>). These have included the discovery of 'green peas' (a class of compact extremely star-forming galaxies in the local Universe; <a href="http://arxiv.org/abs/0907.4155">Cardamone et al. 2009</a>) and perhaps most famously "Hanny's Voorwerp" (<a href="http://arxiv.org/abs/0906.5304">Lintott et al. 2009</a>) along with a survey of similar AGN-ionised gas clouds (<a href="http://arxiv.org/abs/1110.6921">Keel et al. 2012</a>). The availability of a large sample of galaxies with both color and morphological information has led to the important realisation that color, not morphology, is most strongly correlated with environment (<a href="http://arxiv.org/abs/0805.2612">Bamford et al. 2009</a>; <a href="http://arxiv.org/abs/0811.3970">Skibba et al. 2009</a>), leading to intriguing subclasses of galaxies like red spiral galaxies (<a href="http://arxiv.org/abs/0910.4113">Masters et al. 2010</a>) and blue ellipticals (<a href="http://arxiv.org/abs/0903.3415">Schawinski et al. 2009</a>).'''
    
    relaunched:
      heading: 'Galaxy Zoo Relaunched'
      sdss: '''The current site incorporates new images from SDSS DR8 (the Southern Galactic cap area), increasing the sample size of galaxies in the local universe by 40%. It also, for the first time, incorporates images from CANDELS, the largest HST Treasury Program. This survey is designed to take advantage of the advent of HST's Wide Field Camera 3 (WFC3) is rapidly opening up a new window into galaxies at z > 1 – the first 50% of the lifetime of the Universe. Previous HST imaging at these epochs has largely sampled the rest-frame ultraviolet, since the available survey instruments (e.g. ACS) have operated in the optical wavelengths. However, the near-infrared capabilities of the WFC3 (a factor of 20 better than NICMOS) are providing us with unprecedented rest-frame optical data of galaxies at z > 1.'''
      candels: 'CANDELS is using the WFC3 near-infrared filters to image 800 arcmin<sup>2</sup> in established HST legacy fields (e.g. GOODS, COSMOS). The near-infrared WFC3 images are particularly important because morphological analysis is best performed in rest-frame optical wavelengths, which trace the underlying stellar population of the galaxy rather than just the UV-bright star-forming regions.'
      combination: 'The combination of the SDSS and CANDELS Galaxy Zoo samples will offer a formidable tool for answering significant open questions that demand a morphological analysis. For example, at what epochs was the Hubble sequence established? How and when were the primordial spheroids formed? What was the relative role of major mergers and secular processes in driving star formation and black hole growth in the early Universe?'
      conclusion: 'The purpose of the Galaxy Zoo project is to answer such questions, prepare the ground for morphological work using future instruments like the JWST and produce samples of morphologically selected high-redshift galaxies for follow-up using instruments like the extremely large telescopes and ALMA.'
  
  
  classify:
    heading: 'Classify'
    restart: 'Restart'
    help: 'Help'
    sloan: 'SDSS'
    hubble: 'Hubble'
    group: 'Group'
    favorite: 'Favourite'
    invert: 'Invert'
  
  
  help:
    title: 'Help'
    examples: 'Examples'
  
  
  home:
    headline: "Few have witnessed what you're about to see"
    call_to_action: 'Experience a privileged glimpse of the distant universe, observed by the Sloan Digital Sky Survey and Hubble Space Telescope'
    
    galaxy_zoo:
      title: 'Classify Galaxies'
      description: "To understand how galaxies formed we need your help to classify them according to their shapes. If you're quick, you may even be the first person to see the galaxies you're asked to classify."
      classify: 'Begin Classifying'
      
    
    galaxy_formation:
      title: 'How Do Galaxies Form?'
      body: 'Roughly one hundred billion galaxies are scattered throughout our observable Universe, each a glorious system that might contain billions of stars. Many are remarkably beautiful, and the aim of Galaxy Zoo is to study them, assisting astronomers in attempting to understand how the galaxies we see around us formed, and what their stories can tell us about the past, present and future of our Universe as a whole. <a data-nav="#/science" href="#/science">more</a>'
    
    history:
      title: 'History of Galaxy Zoo'
      body: '''The launch of this new version of Galaxy Zoo, the 4th, comes just a few weeks after the site’s 5th birthday. It all started back in July 2007, with a data set made up of a million galaxies imaged by the Sloan Digital Sky Survey, who still provide some of the images in the site today. With so many galaxies, we'd assumed it would take years for visitors to the site to work through them all, but within 24 hours of launch we were stunned to be receiving almost 70,000 classifications an hour. In the end, more than 50 million classifications were received by the project during its first year, contributed by more than 150,000 people. <a data-nav="#/story" href="#/story">more</a>'''
    
    classroom:
      title: 'Galaxy Zoo in the Classroom'
      body: 'Are you an educator? Would you like to use Galaxy Zoo with a group of students? The <a href="http://www.galaxyzoo.org/#/navigator/home">Navigator</a> is an interactive tool that allows groups to classify galaxies together and then investigate galaxy characteristics. <a href="http://www.zooteach.org/zoo/galaxy_zoo">Zoo Teach</a> is where educators can share lessons, resources and that compliment the citizen science projects that are part of the Zooniverse.'
      navigator: 'Navigator'
    
    recent_images:
      title: 'Recent Images'
  
  
  login_prompt:
    title: 'Login or create an account to receive credit for your work'
    decline: 'No, thanks'
  
  
  navigation:
    classify: 'Classify'
    science: 'Science'
    blog: 'Blog'
    team: 'Team'
    papers: 'Papers'
    data: 'Data'
    story: 'Story'
    galaxy_zoo: 'Galaxy Zoo'
    astronomers: 'Astronomers'
    discuss: 'Discuss'
    talk: 'Talk'
    forum: 'Forum'
    profile: 'Profile'
  
  
  papers:
    title: 'Published Papers'
    description: 'The efforts of the Galaxy Zoo community has resulted in fantastically rich dataset with which to do science. Below is a list of just some of the publications that have come about because of the classifications collected on Galaxy Zoo.'
    available: 'available here'
  
  
  profile:
    favorites: 'Favourites'
    recents: 'Recents'
    remove_favorite: 'Remove this favourite'
    favorite_this: 'Favourite this'
    classifications: 'Classifications'
    hubble: 'Hubble'
    hubble_classifications: 'Hubble Classifications'
    sdss: 'SDSS'
    sdss_classifications: 'SDSS Classifications'
    quiz: 'Quizzes'
    quizzes: 'Quizzes'
    quizzes_taken: 'Quizzes Taken'
    take_a_quiz: 'Take a quiz now'
    galaxy_zoo_hubble: 'Galaxy Zoo: Hubble'
    galaxy_zoo_hubble_link: '''If you're looking for your old galaxies from Galaxy Zoo Hubble, then you can <a href="http://hubble.galaxyzoo.org/my_galaxies" target="_blank">find them here</a>.'''
  
  
  science:
    title: 'The Science behind the Site'
    p1: 'Roughly one hundred billion galaxies are scattered throughout our observable Universe, each a glorious system that might contain billions of stars. Many are remarkably beautiful, and the aim of Galaxy Zoo is to study them, assisting astronomers in attempting to understand how the galaxies we see around us formed, and what their stories can tell us about the past, present and future of our Universe as a whole.'
    p2: "Our strategy is based on the remarkable fact that you can tell a lot about a galaxy just from its shape. Find a system with spiral arms, for example, and normally - but critically not always - you'll know that you're looking at a rotating disk of stars, dust and gas with plenty of fuel for future star formation. Find one of the big balls of stars we call ellipticals, however, and you're probably looking at a more mature system, one which long ago finished forming stars. The galaxies' histories are also revealed; that elliptical is likely to be the product of a head-on collision between two smaller galaxies, and smaller scars such as warped disks, large bulges or long streams of stars bear testament to the complexity of these galaxies' lives."
    p3: "We've already said that a merger can have a major impact on a galaxy’s appearance, but many other factors could have played an important role; for example, there is steadily growing evidence (not least from previous Galaxy Zoo projects) that the black holes that lurk at the heart of galaxies may have a profound effect on their surroundings."
    p4: 'As material falls towards the black hole, it can be heated to enormous temperatures and the resulting radiation packs a powerful punch, sometimes aided by the presence of powerful jets of materials flung away from the vicinity of the black hole (though not, of course, from the black hole itself) at close to the speed of light. These combination of forces can, it seems, heat or expel gas from the galaxy, depriving it of fuel for future star formation and changing its face for ever.'
    p5: "A galaxy's surroundings matter too. At the centre of the Virgo cluster, our nearest large group of galaxies, mergers between systems are rare - held by the cluster’s powerful gravitational grip, galaxies are moving too fast for more than brief encounters. In the emptiest parts of space, the density of galaxies is just too low for mergers to play a significant role, and so it’s only on the outskirts of clusters or in small groups like our own Local Group that mergers currently play a significant part. It should come as no surprise, then, that we find different types of galaxies in different places, and this too must be taken into account."
    p6: "Disentangling these effects, and many more, requires the largest possible samples of classified galaxies. It’s not uncommon for us to need, for example, a large sample of red, barred, spiral galaxies that reside on the edges of clusters, and if we don't have a large sample to begin with there will be none left when we've narrowed the search. Modern surveys provide enough images - hundreds of thousands upon hundreds of thousands of them - but we still need people to classify them. That's where you come in..."
    subtitle: 'Where do the images come from?'
    p7: 'The Sloan Digital Sky Survey (SDSS) started in 2000 and is one of the first, and largest, digital maps of the Universe available to astronomers. The original SDSS, which ran for 5 years, included two main instruments, namely a 126 megapixel imaging camera and two fiber-fed spectrographs, mounted on a dedicated 2.5 meter telescope at Apache Point Observatory in New Mexico. During good weather, the SDSS undertook draft-scan imaging of the northern sky using the camera, while in cloud conditions the SDSS obtained spectra of a sub-set of detected objects to measure their redshift and thus distance. From 2005 to 2008, the second phase of SDSS, or SDSS-II, continued to survey the north galactic cap of our Galaxy as well as undertaking a new supernova survey and a new spectroscopic survey of stars (SEGUE). Since 2008, the third incarnation of the SDSS, or SDSS-III, has focused exclusively on spectroscopy (the imaging camera has been retired to the Smithsonian Museum) and comprises of four sub-surveys of BOSS, APOGEE, SEGUE and MARVELS.'
    p8: 'The scientific legacy of the SDSS is amazing, partly due to the annual release of SDSS data to the astronomical community and public. For example, in 2011, the SDSS collaboration published its eighth data release (DR8), which contains 14,555 square degrees of optical imaging data (with over a trillion pixels), and contains 932 million unique objects, of which 1.63 million objects possessed a SDSS spectrum. This awesome astronomical resource is freely available via a state-of-the-art database. Astronomers have written over 4000 papers (approximate one a day) using SDSS public data, gaining over 175,000 citations. Within the SDSS collaboration, there have been more than 120 PhD theses, while the SDSS data fueling numerous high impact outreach projects e.g. Galaxy Zoo. The SDSS has been named several times the highest impact project, facility or mission in the field of astronomy (Madrid & Macchetto 2006, 2009), and is the source of the most highly cited astronomy article in the years 2000, 2002, 2005, and 2008 (Frogel et al. 2010).'
    p9: 'The SDSS would not have been possible without a large collaboration of scientists, researchers and astronomers. Many of the astronomers involved in the original SDSS have now moved on in their careers, spreading their experience within large collaborations across the world. At the start of the SDSS, such large collaborations in astronomy were rare and the SDSS has also been at the forefront of changing the culture of collaborative research in astrophysics. The SDSS is now planning a new 4th phase starting 2014. This phase will involve a number of targeted surveys including eBOSS, MaNGA and APOGEE-S2, which are designed to simultaneously explore the distant universe, the dynamics of nearby galaxies, and study stars in our own Galaxy. By the end of this 4th phase, the SDSS will have provided excellent data for over two decades, resulting in over 5 million astronomical spectra.'
    p10: '''As we peer deeper into the universe, we look into the past, and since the universe is expanding, the galaxies we see are moving away from us faster and faster. This means that the light that left them gets stretched by the time it reaches us. Thus, the light from stars gets "redshifted" and to get a visible light image of a galaxy in the early universe, we need an infrared camera. Taking infrared images is much harder than optical ones for many reasons, but the most important one is that the night sky actually glows in the infrared. This fundamentally limits our ability to take deep infrared images, which is why Hubble's new Wide Field Camera 3 (WFC3) with its infrared capability is so valuable.'''
    p11: 'A new generation of surveys using the WFC3 is giving us an unprecedented view into the first third of the lifetime of the Universe: the first 3-4 billion years after the Big Bang. Foremost among these is the Cosmic Assembly Deep Extragalactic Near-infrared Survey (CANDELS). The largest treasury survey using the Hubble Space Telescope to date, CANDELS is surveying several patches of sky to put together the largest collection of deep infrared images of galaxies in the early Universe. The combination of Galaxy Zoo and CANDELS offers a formidable tool in our quest to understand the earliest stages of the evolution of the visible Universe, one of the fundamental questions in observational cosmology today.'
  
  
  story:
    title: 'The Story So Far'
    p1: "The launch of this new version of Galaxy Zoo, the 4th, comes just a few weeks after the site's 5th birthday. It all started back in July 2007, with a data set made up of a million galaxies imaged by the Sloan Digital Sky Survey, who still provide some of the images in the site today. With so many galaxies, we'd assumed it would take years for visitors to the site to work through them all, but within 24 hours of launch we were stunned to be receiving almost 70,000 classifications an hour. In the end, more than 50 million classifications were received by the project during its first year, contributed by more than 150,000 people."
    p2: "That meant that each galaxy was seen by many different participants. This is deliberate; having multiple independent classifications of the same object is important, as it allows us to assess how reliable our results are. For example, for projects where we may only need a few thousand galaxies but want to be sure they're all spirals before using up valuable telescope time on them, there's no problem - we can just use those that 100% of classifiers agree are spiral. For other projects, we may need to look at the properties of hundreds of thousands of galaxies, and can use those that a majority say are spiral."
    p3: '''The task in that first Galaxy Zoo was slightly simpler than yours; all we asked volunteers to do was to split the galaxies into ellipticals, mergers and spirals and - if the galaxy was spiral - to record the direction of the arms. But it was enough to show that the classifications Galaxy Zoo provides were as good as those from professional astronomers, and were of use to a large number of researchers. You can find out what people have been up to with Galaxy Zoo data in our list of <a href="#/papers" data-nav="/papers">papers published</a> and on the <a href="http://blog.galaxyzoo.org" target="_blank">Galaxy Zoo blog</a>, as well as below. Perhaps the most exciting sign of success is the fact that we’ve been successful in bidding for time on some of the largest telescopes in the world to follow up on many Galaxy Zoo discoveries : the list currently includes the Isaac Newton and William Herschel Telescopes on the island of La Palma in the Canaries, Gemini South in Chile, the WIYN telescope on Kitt Peak, Arizona, the IRAM radio telescope in Spain's Sierra Nevada, Swift, GALEX, Chandra, XMM-Newton and Suzaku up in space, and perhaps most excitingly the Hubble Space Telescope.'''
    p4: "Galaxy Zoo 2 was inspired by our newfound confidence in the ability of you, our volunteer classifiers, and so we asked for a closer look at just over 200,000 of the brightest of the Sloan galaxies. We asked about the number of spiral arms, the size of the galaxies' bulges and much else besides. Once again, we were thrilled with the response (and a little more prepared for it than we were for Zoo 1!) and in the 14 months the site was up we received a little more than 60 million classifications."
    p5: "Along the way, we added more detailed images from an area of the survey known as 'Stripe 82', but it was soon time to look at the more distant Universe. The site’s third incarnation, Galaxy Zoo : Hubble drew from surveys conducted by the Hubble Space Telescope to view earlier epochs of galaxy formation. In these surveys, which involve many, many days of dedicated observing time, we can see light from galaxies which has taken billions of years to reach us. The idea behind Galaxy Zoo : Hubble was to be able to compare galaxies then to galaxies now, giving us a clear understanding of what factors influence their growth, whether through mergers, active black holes or simply star formation."
    p6: '''The present day Galaxy Zoo combines new imaging from Sloan, giving us our best ever view of the local Universe, with the most distant images yet from Hubble's CANDELS survey. The <a href="http://candels.ucolick.org" target="_blank">CANDELS survey</a> makes use of the new Wide Field Camera 3 - installed during the final shuttle mission to Hubble - to take ultra-deep images of the Universe, so who knows what's out there to be found?'''
  
  
  team:
    title: 'The Galaxy Zoo Team'
    science:
      title: 'Science Team'
      bamford: '<span class="person">Steven Bamford</span> - Astronomer, University of Nottingham<br />Works on figuring out what makes galaxies look the way they do: how they formed and why they change as they get older and move to new cosmic locations.  When not busy working on science or doing his bit to help run the Zooniverse, he is usually to be found entertaining his two young children or sailing a boat.'
      lintott: '''<span class="person">Chris Lintott</span> - Astronomer, University of Oxford<br />Between Galaxy Zoo, co-presenting the BBC's Sky at Night program and writing for <a href="http://www.chrislintott.net">www.chrislintott.net</a> and elsewhere, Chris usually wishes he had more time to sleep.'''
      schawinski: '<span class="person">Kevin Schawinski</span> - Astronomer, <a href="http://www.astro.ethz.ch" target="_blank">ETH Zurich</a><br />Works on the formation and evolution of galaxies and their supermassive black holes. Usually trying to get more sleep. And coffee.'
      edmondson: '<span class="person">Edd Edmondson</span> - Astronomer, University of Portsmouth<br />Zookeeper, aiding in accessing Sloan data, and general helper-outer.'
      keel: '''<span class="person">Bill Keel</span> - Astronomer, <a href="http://astronomy.ua.edu/keel" target="_blank">University of Alabama</a><br />Author of 'The Road to Galaxy Formation' and 'The Sky at Einstein's Feet'. With research interests in galaxy formation and evolution, dust content of galaxies, and active galactic nuclei, he couldn't stay away when Galaxy Zoo got started.'''
      skibba: '<span class="person">Ramin Skibba</span> - Astronomer, UC San Diego<br />Leading the use of marked correlation functions to analyse the Galaxy Zoo morphologies.'
      cardamone: '''<span class="person">Carie Cardamone</span> - Astronomer, <a href="https://sites.google.com/a/brown.edu/ccardamone/" target="_blank">Brown University</a><br />An educator and astronomer, studying the Zoo's green peas, interested in understanding why galaxies grow they way they do. She's very enthusiastic about engaging the broader public in scientific research and the nature of science.'''
      willett: '<span class="person">Kyle Willett</span>, University of Minnesota<br />Works on environments of galaxies with active black holes, assembling the final catalogs for Galaxy Zoo 2, and new tools for the Zooniverse sites. Probably runs more than is healthy.'
      urry: '<span class="person">Meg Urry</span> - Physicist, Yale University<br />Works on supermassive black holes (growth history, unification, relativistic jets, blazars) and their interplay with galaxies. In her spare time, she writes for CNN.com and works to increase the participation of women and minorities in science.'
      nichol: '''<span class="person">Bob Nichol</span> - Cosmologist, University of Portsmouth<br />An astronomer, astrophysicist and cosmologist with interests in computer science and statistics. A senior member (or 'Builder') of the Sloan Digital Sky Survey, the most ambitious digital survey of the sky ever undertaken. A long suffering supporter of Manchester City, suffering no more.'''
      fortson: '''<span class="person">Lucy Fortson</span> - Astrophysicist, University of Minnesota<br />Interested in galaxy evolution, black holes and the jets of material beaming from the centers of active galactic nuclei. Started the Zooniverse effort at the Adler Planetarium, now bringing the light to the University of Minnesota. On the odd weekend, when she's not preparing lecture or writing grants, Lucy can be found hanging out with her husband and son at one of Minneapolis' fine dining establishments.'''
      masters: '''<span class="person">Karen Masters</span> - Astronomer, University of Portsmouth<br />Interested in spiral galaxies of all kinds, red has always been her favourite colour. She's working to disentangle the 'true' red spirals, from those that are reddened because we see them edge on, and along the way learn about interstellar dust, and the nature of red spirals themselves. Bars also a speciality.'''
      melvin: '<span class="person">Tom Melvin</span> - Astronomer, University of Portsmouth<br />A PhD student currently studying the formation and evolution of bars in disk galaxies.'
      szalay: '''<span class="person">Alex Szalay</span> - Cosmologist, Johns Hopkins University<br />One of the creators of the SDSS SkyServer, and currently involved in building the Virtual Observatory. Plays some music in his 'spare' time.'''
      thomas: '''<span class="person">Daniel Thomas </span>- Astronomer, University of Portsmouth<br />Interested in galaxies of any shape, age, colour and habitat in the universe. When he's not sunbathing, his research focuses on the stars in galaxies and what they tell us about galaxy formation and evolution.'''
      haussler: '<span class="person">Boris H&auml;u&szlig;ler</span> - Astronomer, University of Nottingham<br />An expert on analysing Hubble Space Telescope images and automatic morphology methods.'
      hoyle: '<span class="person">Ben Hoyle</span> - Astronomer, University of Portsmouth<br />Currently developing exciting connections between Google Sky and Galaxy Zoo. Also working on using the lensing of distant quasars to learn about the properties of nearby Galaxy Zoo galaxies.'
      kaviraj: '<span class="person">Sugata Kaviraj</span> - Astronomer, University of Oxford<br />Studying the Galaxy Zoo mergers.'
      raddick: '<span class="person">Jordan Raddick</span> - Science Education and Outreach Coordinator, Johns Hopkins University<br />A science writer and educator, creator of the science projects on the SDSS SkyServer web site, and an avid science fiction reader and writer. Jordan wishes he could visit galaxies in their natural habitat.'
      wong: '<span class="person">Ivy Wong</span> - Astronomer, CSIRO'
    
    dev:
      title: 'Zooniverse Development Team'
      kapadia: '<span class="person">Amit Kapadia</span><br />Amit Kapadia develops astronomical web applications. He is a citizen science developer for the crowd-sourcing based platform Zooniverse. New to the world of JavaScript he spends his days dreaming of conducting in-browser analyses on astronomical data sets. On occasion he flexes his modest sway to advocate for more modern solutions to data access in astronomy. He believes the scientific world needs to speak more closely with the tech world, and constantly strives to learn more from the latter. Amit is often found at the Adler Planetarium in Chicago.'
      carstensen: '<span class="person">Brian Carstensen</span><br />Brian is a web developer working on the Zooniverse family of projects at the Adler Planearium. Brian has a degree in graphic design from Columbia College in Chicago, and worked in that field for a number of years before finding a niche in web development.'
      miller: '''<span class="person">David Miller</span><br />As a visual communicator, David is passionate about tellings stories through clear, clean, and effective design. Before joining the Zooniverse team as Visual Designer, David worked for The Raindance Film Festival, the News 21 Initiative's Apart From War, Syracuse Magazine, and as a freelance designer for his small business, Miller Visual. David is a graduate of the S.I. Newhouse School of Public Communications at Syracuse University, where he studied Visual & Interactive Communications.'''
      paget: '<span class="person">Ed Paget</span><br />Ed somehow went from studying Film at Northwestern University to joining the Zooniverse team as a software developer. Along the way, he picked up a little programming. In his spare time, he enjoys photography, chess, fencing, and growing his beard.'
      parrish: '<span class="person">Michael Parrish</span><br />Michael has a degree in Computer Science and has been working with The Zooniverse for the past three years as a Software Developer. Aside from web development; new technologies, science, AI, reptiles, and coffee tend to occupy his attention.'
      simpson: '<span class="person">Robert Simpson</span><br />Zooniverse Researcher and developer at Oxford University. PI of the <a href="http://www.milkywayproject.org/" target="_blank">Milky Way Project</a>.'
      smith: '<span class="person">Arfon Smith</span><br />As an undergraduate, Arfon studied Chemistry at the University of Sheffield before completing his Ph.D. in Astrochemistry at The University of Nottingham in 2006. He worked as a senior developer at the Wellcome Trust Sanger Institute (Human Genome Project) in Cambridge before joining the Galaxy Zoo team in Oxford. Over the past 3 years he has been responsible for leading the development of a platform for citizen science called Zooniverse. In August of 2011 he took up the position of Director of Citizen Science at the Adler Planetarium where he continues to lead the software and infrastructure development for the Zooniverse.'
      whyte: '''<span class="person">Laura Whyte</span><br />Having spent her PhD trying to get computers to classify galaxies, Laura know only to well the true value of the contribution to science made by the Galaxy Zoo volunteers. Since leaving astronomy she has retrained as a Maths teacher and picked up a few programming skills. It was with great delight she joined the team at the Zooniverse, developing online education and research tools, allowing her to use bits and pieces of all the skills she's picked up over the last decade.'''
    
    czech:
      title: 'Galaxy Zoo Czech Support Team'
      vykouril: '<span class="person">Dušan Vykouřil</span><br />Initiator, and coordinator Czech Galaxy Zoo. He thinks that line of the universe is never-ending. He like pushes the limits of the unknown.'
      moudra: '<span class="person">Míla Moudrá</span><br />Main Czech Galaxy Zoo translator. Student from Prague, Czech republic, and amateur astronomer, especially deep-sky objects (i.e. galaxies, among others) visual observer. Interested in protection of environment and small rodents :-)'
      hresil: '<span class="person">Petr Hřešil</span><br />Czech Galaxy Zoo co-translator. He has always been fascinated by the sky and the universe but he got trapped into the IT world and fell into the clutches of the Internet. Fan of Distributed computing, lover of sci-fi which allows him to set out "Where No One Has Gone Before".'
      miksovsky: '<span class="person">Jaroslav Mikšovský</span><br />Czech Galaxy Zoo corrector. Pensioner still economically active.'
    
    french:
      title: 'Galaxy Zoo France Support Team'
      marco: '<span class="person">Olivier Marco</span> - Observatoire de Paris'
    
    german:
      title: 'Galaxy Zoo Germany Support Team'
      poessel: '<span class="person">Markus Poessel</span> - Center for Astronomy Education and Outreach, Heidelberg<br />German Galaxy Zoo co-translator. Managing scientist of the Center for Astronomy Education and Outreach in Heidelberg, whose galaxy-shaped building has a disk, is not clumpy, can be viewed edge-on, has two spiral arms that are medium-tightly wound, and an obvious bulge. (And please tell him if you notice anything odd.).'
      leifke: '<span class="person">Carolin Leifke</span> - Center for Astronomy Education and Outreach, Heidelberg<br />German Galaxy Zoo co-translator. Observes flares on active stars with X-ray satellites and the VLT, and galaxies of all kind with her 16-inch Dobsonian. Has now turned her passion for astronomy education and outreach into a profession.'
    
    polish:
      title: 'Galaxy Zoo Poland Support Team'
      biernacki: '<span class="person">Paweł Biernacki</span><br />Student of astronomy at Wrocław University, enthusiast of the Sun, addicted to sci-fi books; upbeaten optimist and fan of soccer.'
      czart: '<span class="person">Krzysztof Czart</span><br />An astronomer and PhD student in a city where Nicolaus Copernicus was born, investigating the biggest stars in galaxies (those from Earth, too). In a spare time, he is a journalist as editor-in-chief of the Polish Astronomy Portal.'
      czernik: '<span class="person">Tomasz Czernik</span><br />Loves astronomy and photography. The youngest team member.'
      kolodziej: '<span class="person">Mirek Kołodziej</span><br />Galaxy Zoo translator, lover of the sky, IT student in secoundary school in Niepolomice, in spare time bard, he tried to bend a spoon with willpower.'
      kotarba: '<span class="person">Marta Kotarba</span><br />Marta has worked on the Polish version of Galaxy Zoo 2. Normally she spends her time setting puzzles, photographing and trying to study astronomy at Jagiellonian University.'
      majcher: '<span class="person">Ariel Majcher</span><br />An astronomer and astrophotographer, likes watching sky through a telescope. This is the reason that he dreams about removal from Poland to Malta at least (along with the temperature in winter).'
      mankiewicz: '''<span class="person">Lech Mankiewicz</span><br />Hunts for fast optical transients in the sky. Coordinator of the 'Pi of the sky' robotic telescope project and father of Agnieszka. In his spare time coordinates the EU-HOU project.'''
      ogloza: '<span class="person">Waldemar Ogloza</span><br />An astronomer from Pedagogical University of Kracow, variable star observer. He devotes his spare time to astronomical education and sailing.'
      pomierny: '<span class="person">Jan Pomierny</span><br />Founder and team leader of the Polish Astronomy Portal. Philosophy and classical music enthusiast who rests in mountains.'
      skowron: '<span class="person">Tomasz Skowron</span><br />Astronomy amateur and educator. Daily teacher of physics and astronomy in secondary school in Szczecin.'
    
    retired:
      title: 'Retired members of the Galaxy Zoo Team'
      andreescu: '<span class="person">Dan Andreescu</span><br />Consultant by day, programmer and seeker of knowledge and fun by night. Avid basketball player and rookie surfer on the weekends.'
      land: '<span class="person">Kate Land</span><br />Added some much-missed glamour to the world of Theoretical Cosmology. Once could not sleep at night for thoughts about the early Universe, but slept during seminars instead. Now lured away by the bright lights of the City.'
      vandenberg: '<span class="person">Jan VandenBerg</span><br />Ringleader of the IT support circus in the JHU Physics & Astronomy department.'
      wonders: '<span class="person">Alainna Wonders</span><br />Tightrope walker therein.'
      locksmith: '<span class="person">Danny Locksmith</span> - Volunteer Programmer<br />Responsible for wrestling the Galaxy Zoo 2 beta site into existence.'
      murray: '<span class="person">Phil Murray</span> - Web Designer, Artist and Managing Director of Fingerprint Digital Media Responsible for the visual design of the Galaxy Zoo web site. Designer of <a href="http://www.banguniverse.com" target="_blank">www.banguniverse.com</a> for Brian May, Patrick Moore and Chris Lintott. A keen musician and lapsed tennis and soccer player.'
      slosar: '<span class="person">Anze Slosar</span> - Cosmologist, Berkeley Center for Cosmological Physics<br />A theoretical physicist, who has has never sat behind a telescope, likes to drink good beer and wishes he were richer.'
      darg: '<span class="person">Daniel Darg</span> - Astronomer, University of Oxford<br />Working on measuring the number and properties of galaxy mergers identified in Galaxy Zoo.'
  
  
  examine:
    title: 'Examine'
    survey: 'Survey'
    right_ascension: 'Right Ascension'
    declination: 'Declination'
    magnitude: 'Magnitude'
    ned_link: 'Search NED'
    discuss: 'Discuss this'
    hubble: 'Hubble'
    sdss: 'SDSS'
    sdss_id: 'SDSS ObjectId'
    petro_rad: 'Petrosian Radius'
    skyserver_link: 'View on SkyServer'
  
  
  fits:
    view: 'View raw data in different wavelengths'
    x_y: 'X, Y'
    intensity: 'Intensity'
    color: 'Color'
    linear: 'Linear'
    logarithm: 'Logarithm'
    square_root: 'Square Root'
    arcsinh: 'Arcsinh'
    power: 'Power'
  
  
  quiz:
    thanks: 'Thanks!'
    help: 'Galaxy Zoo needs your help!'
    research: 'We are doing research to better understand what Galaxy Zoo volunteers think about the universe.'
    helping: 'You are helping us better understand what Galaxy Zoo volunteers think about the universe.'
    gift: 'You have been entered into a raffle to win a <strong>$20 Amazon Gift Certificate</strong>.'
    reward: 'As a reward, each time you complete a set of questions you will be entered in a raffle to win a <strong>$20 Amazon Gift Certificate</strong>.'
    now_or_later: 'You can take another quiz now, or later by visiting your profile.'
    start_next: 'When would you like to take the next set of questions?'
    reminder: 'You have previously agreed to be asked a set of 5&ndash;6 short questions once every week.'
    ready: 'Are you ready?'
    now: 'Now'
    later: 'Later'
    complete: 'You have completed all the quizzes!'
    okay: 'Okay'
    participate: 'Would you like to participate?'
    yes: 'Yes!'
    no_thanks: 'No, thanks'
    ask_later: 'Ask later'
    never_again: 'Never ask again'
    
    example:
      prompt: 'If you agree to help you will be given short surveys that contain 6 multiple choice questions, which you can answer at your own pace. The first survey is available immediately after you agree to participate.<br />A question might be:'
      question: "Hubble's observation that galaxies farther away from us are moving faster led to which conclusion?"
      answer_a: 'The universe is expanding'
      answer_b: 'The universe is contracting'
      answer_c: 'We are located at the center of the universe'
      answer_d: 'Our galaxy repels other galaxies'
  
  
  navigator:
    title: 'Navigator'
    construct: 'Construct Your Question'
    my_galaxies: 'My Galaxies'
    graph: 'Graph Data'
    loading: 'Loading...'
    reset: 'Reset Graph'
    snapshot: 'Take Snapshot'
    download: 'Download Data'
    n_galaxies: '# of Galaxies'
    smooth: 'Smooth'
    feature: 'Features or disk'
    star: 'Star or artifact'
    redshift: 'Redshift'
    color: 'Color'
    apparent_brightness: 'Apparent Brightness'
    absolute_radius: 'Absolute Radius'
    absolute_brightness: 'Absolute Brightness'
    no_results: 'You need to classify galaxies first'
    intro: "Welcome to the Galaxy Zoo Navigator, where you can investigate the galaxy classifications you have made as part of a group. To get started you will need to select the group you'd like to work with."
    credit: 'The Navigator is based upon work supported by the National Science Foundation under Grants No. 1041419 and 0941610. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.'
    
    groups:
      select: 'Select Group'
      create: 'Create New Group'
      classify: 'Classify Galaxies'
      group_classify: 'Classify in Group'
      stop_classify: 'Stop Classifying in Group'
      leave: 'Leave Group'
      destroy_group: 'Delete Group'
      classify_desc: 'Visit the Galaxy Zoo website to classify galaxies as part your group.'
      stats: 'Statistics'
      invitations: 'Invitations'
      enter_name: 'Enter Group Name'
      enter_emails: 'Invite users by entering their emails seperated with a comma (e.g. ed@example.com, cs@example.com, whyte@example.com)'
      send_invites: 'Send Invites'
      disable_talk: 'Disable Talk for this Group'
      invited_users: 'Users Invited'
      participation: 'Participation'
      compare: 'Compare your classification choices with those made by other volunteers.'
      confirm_leave: 'Are you sure?\nThe Group Leader must re-invite you if you wish to rejoin'
      confirm_destroy: 'Are you sure?\nThere is no undo.'
      ensure_selected: 'Select a group or create one from the dropdown menu to see your group classifications'
    
    sample:
      label: 'with a sample size of...'
      choose: 'Choose sample size'
      small: 'Small Sample of Galaxies'
      random_small: 'Small Random Sample of Galaxies'
      medium: 'Medium Sample of Galaxies'
      random_medium: 'Medium Random Sample of Galaxies'
      large: 'Large Sample of Galaxies'
      random_large: 'Large Random Sample of Galaxies'
    
    galaxy_type:
      label: 'in the following galaxy type...'
      smooth: 'Smooth'
      feature: 'Feature/Disk'
    
    source:
      label: "I'd like to use data from..."
      my_group: 'My Group'
      galaxy_zoo: 'Galaxy Zoo'
      my_choice: 'My choice'
    
    histogram:
      title: 'Histogram'
      description: 'Investigate the characteristics of different galaxy types.'
      label: "'I'd like to see...'"
      y_label: 'Number of Galaxies'
      distribution: 'Distribution of'
      distributed: 'is distributed across...'
      one_var: 'One-Variable'
      two_var: 'Two-Variable'
      create: 'Create Graph'
    
    scatterplot:
      title: 'Scatter Graph'
      description: 'Compare the characteristics of different galaxy types.'
      label: "I'd like to see how..."
      vs: 'vs.'
      relation: 'relates to...'
      choose_x: 'Choose the x-axis variable'
      choose_y: 'Choose the y-axis variable'
