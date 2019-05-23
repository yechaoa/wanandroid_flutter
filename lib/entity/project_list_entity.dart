class ProjectListEntity {
	ProjectListData data;
	int errorCode;
	String errorMsg;

	ProjectListEntity({this.data, this.errorCode, this.errorMsg});

	ProjectListEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new ProjectListData.fromJson(json['data']) : null;
		errorCode = json['errorCode'];
		errorMsg = json['errorMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
}

class ProjectListData {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<ProjectListDataData> datas;

	ProjectListData({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	ProjectListData.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<ProjectListDataData>();(json['datas'] as List).forEach((v) { datas.add(new ProjectListDataData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['over'] = this.over;
		data['pageCount'] = this.pageCount;
		data['total'] = this.total;
		data['curPage'] = this.curPage;
		data['offset'] = this.offset;
		data['size'] = this.size;
		if (this.datas != null) {
      data['datas'] =  this.datas.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class ProjectListDataData {
	String superChapterName;
	int publishTime;
	int visible;
	String niceDate;
	String projectLink;
	String author;
	String prefix;
	int zan;
	String origin;
	String chapterName;
	String link;
	String title;
	int type;
	int userId;
	List<ProjectListDataDatasTag> tags;
	String apkLink;
	String envelopePic;
	int chapterId;
	int superChapterId;
	int id;
	bool fresh;
	bool collect;
	int courseId;
	String desc;

	ProjectListDataData({this.superChapterName, this.publishTime, this.visible, this.niceDate, this.projectLink, this.author, this.prefix, this.zan, this.origin, this.chapterName, this.link, this.title, this.type, this.userId, this.tags, this.apkLink, this.envelopePic, this.chapterId, this.superChapterId, this.id, this.fresh, this.collect, this.courseId, this.desc});

	ProjectListDataData.fromJson(Map<String, dynamic> json) {
		superChapterName = json['superChapterName'];
		publishTime = json['publishTime'];
		visible = json['visible'];
		niceDate = json['niceDate'];
		projectLink = json['projectLink'];
		author = json['author'];
		prefix = json['prefix'];
		zan = json['zan'];
		origin = json['origin'];
		chapterName = json['chapterName'];
		link = json['link'];
		title = json['title'];
		type = json['type'];
		userId = json['userId'];
		if (json['tags'] != null) {
			tags = new List<ProjectListDataDatasTag>();(json['tags'] as List).forEach((v) { tags.add(new ProjectListDataDatasTag.fromJson(v)); });
		}
		apkLink = json['apkLink'];
		envelopePic = json['envelopePic'];
		chapterId = json['chapterId'];
		superChapterId = json['superChapterId'];
		id = json['id'];
		fresh = json['fresh'];
		collect = json['collect'];
		courseId = json['courseId'];
		desc = json['desc'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['superChapterName'] = this.superChapterName;
		data['publishTime'] = this.publishTime;
		data['visible'] = this.visible;
		data['niceDate'] = this.niceDate;
		data['projectLink'] = this.projectLink;
		data['author'] = this.author;
		data['prefix'] = this.prefix;
		data['zan'] = this.zan;
		data['origin'] = this.origin;
		data['chapterName'] = this.chapterName;
		data['link'] = this.link;
		data['title'] = this.title;
		data['type'] = this.type;
		data['userId'] = this.userId;
		if (this.tags != null) {
      data['tags'] =  this.tags.map((v) => v.toJson()).toList();
    }
		data['apkLink'] = this.apkLink;
		data['envelopePic'] = this.envelopePic;
		data['chapterId'] = this.chapterId;
		data['superChapterId'] = this.superChapterId;
		data['id'] = this.id;
		data['fresh'] = this.fresh;
		data['collect'] = this.collect;
		data['courseId'] = this.courseId;
		data['desc'] = this.desc;
		return data;
	}
}

class ProjectListDataDatasTag {
	String name;
	String url;

	ProjectListDataDatasTag({this.name, this.url});

	ProjectListDataDatasTag.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['url'] = this.url;
		return data;
	}
}
