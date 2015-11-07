---
layout: post
title: "Android - PDF Viewer"
date: 2010-09-01 00:45:00
tag: [Android, PDF]
categories:
- blog
- Android
---

{% highlight java linenos %}
private File pdf = null;
private final String PDF_PATH = "/sdcard/download/B.pdf";
private Intent intent;

@Override
protected void onCreate(Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   setContentView(R.layout.pdf);
   pdf = new File(PDF_PATH);
   if(pdf.exists() && pdf.isFile() && pdf.canRead()){
      intent = new Intent(Intent.ACTION_DEFAULT);
      intent.setType("application/pdf");
      intent.putExtra(Intent.EXTRA_STREAM, Uri.parse(Environment.getExternalStorageDirectory() + PDF_PATH));

      startActivity(intent);
   }
}
{% endhighlight %}
